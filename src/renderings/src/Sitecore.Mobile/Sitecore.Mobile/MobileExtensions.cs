using System;
using System.Web;

namespace Sitecore.XslHelpers
{
    public class MobileExtensions
    {
        public string htmlEncode(string stringToEscape)
        {
            return HttpUtility.HtmlEncode(stringToEscape);
        }
    }
}
