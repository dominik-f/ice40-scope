using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using OxyPlot;
using OxyPlot.Series;

namespace ICE40Scope
{
    class MainViewModel
    {
        public PlotModel MyModel { get; private set; }

        public MainViewModel(IMainView view)
        {
            view.DataContext = this;

            this.MyModel = new PlotModel { Title = "Example 1" };
            this.MyModel.Series.Add(new FunctionSeries(Math.Cos, 0, 10, 0.1, "cos(x)"));
        }
    }
}
