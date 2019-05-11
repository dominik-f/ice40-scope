using System;
using System.Buffers;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO.Pipelines;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using OxyPlot;
using OxyPlot.Series;

namespace ICE40Scope
{
    class MainViewModel : INotifyPropertyChanged
    {
        private SerialPort mSerialPort;
        private string mComPort;
        private PlotModel mScopeData;
        private LineSeries mLineSeries;

        public event PropertyChangedEventHandler PropertyChanged;

        public string ComPort { get => mComPort; set { mComPort = value; OnPropertyChanged(nameof(ComPort)); } }
        public PlotModel ScopeData { get => mScopeData; private set { mScopeData = value; OnPropertyChanged(nameof(ScopeData)); } }


        public MainViewModel(IMainView view)
        {
            view.DataContext = this;
            view.Start += OnStart;
            view.Stop += OnStop;

            ComPort = "COM10";

            ScopeData = new PlotModel { Title = "Scope" };
        }

        private async void OnStart(object sender, EventArgs e)
        {
            mSerialPort = new SerialPort(ComPort, 115200, Parity.None, 8, StopBits.One);
            try
            {
                mSerialPort.Open();
            }
            catch (Exception)
            {
                Console.WriteLine($"Error opening port {ComPort}");
                return;
            }

            ScopeData.Series.Clear();
            mLineSeries = new LineSeries();
            ScopeData.Series.Add(mLineSeries);

            while (mSerialPort != null && mSerialPort.IsOpen)
            {
                //_ = ProcessDataAsync();
                await ProcessDataAsync();
            }
        }

        private void OnStop(object sender, EventArgs e)
        {
            mSerialPort?.Close();
            mSerialPort?.Dispose();
        }

        private void ProcessAdcData(in ReadOnlySequence<byte> buffer)
        {
            foreach (var bufferElement in buffer)
            {
                foreach (var y in bufferElement.ToArray())
                {
                    var x = mLineSeries?.Points.Count ?? 0;
                    mLineSeries?.Points.Add(new DataPoint(x, y));
                }
            }
        }


        private async Task ProcessDataAsync()
        {
            var pipe = new Pipe();

            Task writing = FillPipeAsync(pipe.Writer);
            Task reading = ReadPipeAsync(pipe.Reader);

            await Task.WhenAll(reading, writing);
        }


        // Read from serial port and fill pipe
        private async Task FillPipeAsync(PipeWriter writer)
        {
            const int minimumBufferSize = 1024;

            while (true)
            {
                try
                {
                    // Request a minimum of 512 bytes from the PipeWriter
                    Memory<byte> memory = writer.GetMemory(minimumBufferSize);

                    // int bytesRead = await serialPort.BaseStream.ReadAsync(memory);  // Only on .Net Core/.Net Standard 2.1
                    int bytesRead = await ReadBytesAsync(memory);
                    if (bytesRead == 0)
                    {
                        break;
                    }

                    // Tell the PipeWriter how much was read
                    writer.Advance(bytesRead);
                }
                catch (Exception)
                {
                    break;
                }

                // Make the data available to the PipeReader
                FlushResult result = await writer.FlushAsync();

                if (result.IsCompleted)
                {
                    break;
                }
            }

            // Signal to the reader that we're done writing
            writer.Complete();
        }

        private async Task<int> ReadBytesAsync(Memory<byte> memory)
        {
            return await Task.Run(() =>
            {
                byte[] poolArray = ArrayPool<byte>.Shared.Rent(memory.Length);
                var len = Math.Min(poolArray.Length, memory.Length);

                int bytesReceived = 0;
                try
                {
                    bytesReceived = mSerialPort?.Read(poolArray, 0, len) ?? 0;
                    if (bytesReceived > 0)
                    {
                        poolArray.AsSpan(0, len).CopyTo(memory.Span);
                    }
                }
                catch (Exception)
                {
                }
                finally
                {
                    ArrayPool<byte>.Shared.Return(poolArray);
                }

                return bytesReceived;
            });
        }

        private async Task ReadPipeAsync(PipeReader reader)
        {
            while (true)
            {
                ReadResult result = await reader.ReadAsync();

                ReadOnlySequence<byte> buffer = result.Buffer;

                ProcessAdcData(buffer);

                // Tell the PipeReader how much of the buffer we have consumed
                reader.AdvanceTo(buffer.Start, buffer.End);

                // Stop reading if there's no more data coming
                if (result.IsCompleted)
                {
                    break;
                }
            }

            // Mark the PipeReader as complete
            reader.Complete();
        }


        public void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
