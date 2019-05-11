using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ICE40Scope
{
    public interface IMainView
    {
        object DataContext { get; set; }

        event EventHandler Start;
        event EventHandler Stop;
    }
}
