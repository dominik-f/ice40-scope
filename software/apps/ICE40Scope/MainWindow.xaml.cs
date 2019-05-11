using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace ICE40Scope
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window, IMainView
    {
        MainViewModel mMainViewModel;

        public event EventHandler Start;
        public event EventHandler Stop;

        public MainWindow()
        {
            InitializeComponent();
            mMainViewModel = new MainViewModel(this);
        }

        private void btnStart_Click(object sender, RoutedEventArgs e)
        {
            Start?.Invoke(sender, EventArgs.Empty);
        }

        private void btnStop_Click(object sender, RoutedEventArgs e)
        {
            Stop?.Invoke(sender, EventArgs.Empty);
        }
    }
}
