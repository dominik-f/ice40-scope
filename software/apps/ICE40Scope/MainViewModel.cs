using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using OxyPlot;
using OxyPlot.Series;

namespace ICE40Scope
{
    class MainViewModel : INotifyPropertyChanged
    {
        private PlotModel mMyModel;

        public event PropertyChangedEventHandler PropertyChanged;
        public PlotModel MyModel { get => mMyModel; private set { mMyModel = value; OnPropertyChanged(nameof(MyModel)); } }


        public MainViewModel(IMainView view)
        {
            view.DataContext = this;

            this.MyModel = new PlotModel { Title = "Example 1" };
            this.MyModel.Series.Add(new FunctionSeries(Math.Cos, 0, 10, 0.1, "cos(x)"));
        }

        public void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
