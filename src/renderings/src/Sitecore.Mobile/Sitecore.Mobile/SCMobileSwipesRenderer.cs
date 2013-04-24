using System;
using System.Web;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Xml;
using Sitecore.Web.UI;
using Sitecore.Data.Items;
using Sitecore.Xml.XPath;

namespace Sitecore.Mobile.Web.UI.WebControls
{
    public class SCMobileSwipesRenderer : WebControl
    {
        // Methods
        // STODO reuse existeed sitecore method
        public virtual Item GetItem(System.Xml.XPath.XPathNodeIterator iterator)
        {
            Sitecore.Data.ID id;
            Sitecore.Data.Version latest;
            Sitecore.Diagnostics.Assert.ArgumentNotNull(iterator, "iterator");
            if (!Sitecore.Data.ID.TryParse(iterator.Current.GetAttribute("id", string.Empty), out id))
            {
                return null;
            }
            if (!Sitecore.Data.Version.TryParse(iterator.Current.GetAttribute("version", string.Empty), out latest))
            {
                latest = Sitecore.Data.Version.Latest;
            }
            Sitecore.Data.Database database = Sitecore.Context.Database;
            if (database == null)
            {
                return null;
            }
            return Sitecore.Data.Managers.ItemManager.GetItem(id, Sitecore.Globalization.Language.Current, latest, database);
        }

        private Item findItemByXpathXMLQuery(Item item, string query)
        {
            try
            {
                ItemNavigator navigator = Sitecore.Configuration.Factory.CreateItemNavigator(item);
                if (navigator != null)
                {
                    System.Xml.XPath.XPathNodeIterator foundItemNavigator = navigator.Select(query);
                    if (foundItemNavigator != null && foundItemNavigator.MoveNext())
                        return GetItem(foundItemNavigator);
                }
            }
            catch (Exception ex)
            {
//                return string.Format("<br>Exeption: {0} for query: {1} </br>", ex.ToString(), query);
            }
            return null;
        }

        private string MobileSwipeLink(HtmlTextWriter output, Item item, string query, string linkType)
        {
            try
            {
                if (string.IsNullOrEmpty(query))
                {
                    return string.Empty;
                }
                Item foundItem = null;
                if (query[0] != '/')
                {
                    Item[] foundItems = item.Axes.SelectItems(item.Paths.Path + "/" + query);
                    if (foundItems != null && foundItems.Length > 0)
                    {
                        foundItem = foundItems[0];
                    }
                }
                else
                {
                    foundItem = item.Axes.SelectSingleItem(query);
                }

                if (foundItem != null)
                {
                    return string.Format("<link rel=\"{0}\" href=\"{1}\">", linkType, Sitecore.Links.LinkManager.GetItemUrl(foundItem));
                }
            }
            catch (Exception ex)
            {
                //return string.Format("<br>Exeption: {0} for query: {1} </br>", ex.ToString(), query);
                //output.Write("<br>Exeption: {0} for query: {1} </br>", ex.ToString(), query);
            }
            return string.Empty;
        }
        private string TrimmedParameterWithName( string ParameterName )
        {
            string result = HttpUtility.ParseQueryString(this.Parameters).Get(ParameterName);
            result = result == null ? null : result.Trim();
            return result;
        }
        private string SwipeRenderings(HtmlTextWriter output)
        {
            string leftSwipeParam  = TrimmedParameterWithName("leftSwipe");
            string rightSwipeParam = TrimmedParameterWithName("rightSwipe");

            if (string.IsNullOrEmpty(leftSwipeParam) && string.IsNullOrEmpty(rightSwipeParam))
            {
                return string.Empty;
            }

            Item item = this.GetItem();

            if (item == null)
            {
                return string.Empty;
            }

            return MobileSwipeLink(output, item, leftSwipeParam, "scm-back")
                 + MobileSwipeLink(output, item, rightSwipeParam, "scm-forward");
        }
        protected override void DoRender(HtmlTextWriter output)
        {
            try
            {
                output.Write(this.SwipeRenderings(output));
            }
            catch (Exception ex)
            {
                output.Write(string.Empty);
            }
        }
    }
}
