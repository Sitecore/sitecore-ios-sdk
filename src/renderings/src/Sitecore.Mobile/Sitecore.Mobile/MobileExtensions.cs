using System;
using System.Web;
using Sitecore.Configuration;

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
