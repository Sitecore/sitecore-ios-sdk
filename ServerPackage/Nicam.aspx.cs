// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Nicam.aspx.cs" company="Sitecore A/S">
//   Copyright (C) 2010 by Sitecore A/S
// </copyright>
// <summary>
//   Defines the nicam class.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

using Dealer.Kernel.BusinessLayer;

namespace Nicam.Layout
{
  using System;
  using System.Web;
  using System.Web.UI;
  using System.Web.UI.HtmlControls;
  // using AnalyticsTrackingHelper.BusinessLayer;
  // using NiCam.Classes;
  // using Sitecore.Analytics.Data;
  using Kernel.BusinessLayer;
  using Sitecore;
  using Sitecore.Analytics;
  using Sitecore.Analytics.Data;
  using Sitecore.Data.Items;
  using Sitecore.Diagnostics;
  using Sitecore.Nicam.Kernel.BusinessLayer;

  // using Sitecore.Nicam.Data.Item;

  /// <summary>
  /// Defines the nicam class.
  /// </summary>
  public partial class Nicam : Page
  {
    /// <summary>
    /// The lock object
    /// </summary>
    private static readonly object Locking = new object();

    /// <summary>
    /// Handles the Load event of the Page control.
    /// </summary>
    /// <param name="sender">The source of the event.</param>
    /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
    protected void Page_Load(object sender, EventArgs e)
    {
      this.htmlpage.Attributes["lang"] = Sitecore.Context.Language.ToString();
      RenderingHelper.AddComponentToDealerProductGroup(this, "/layouts/Dealer/Sublayout/MiniCart.ascx", "phRight");
      RenderingHelper.AddComponentToDealerProduct(this, "/layouts/Dealer/Sublayout/MiniCart.ascx", "phRight");
      RenderingHelper.AddComponentToDealerProduct(this, "/layouts/Dealer/Sublayout/Basket.ascx", "phCenter");

      if (Sitecore.Context.Item != null &&
          Sitecore.Context.Item.Template != null &&
          Sitecore.Context.Item.Template.Name.Equals("Home"))
      {
        this.page_container.Attributes.Add("class", "home_page");
        this.SetBodyClassForHomeItem("index");
      }

      if (Page.IsPostBack)
      {
        // Rate Page
        /*if (VoteClicked())
        {
          this.RatePage();
        }*/

        
        if (GenericPersonalizationSpotLinkButtonClicked())
        {
          this.TrackGenericPersonalizationSpot();
        }
      }
    }

    /// <summary>
    /// Sets the body class for home item.
    /// </summary>
    /// <param name="bodyId">The body id.</param>
    protected void SetBodyClassForHomeItem(string bodyId)
    {
      var c = FindControl(bodyId);
      var body = c as HtmlContainerControl;
      if (body != null)
      {
        body.Attributes.Add("class", "home");
      }
    }

    /// <summary>
    /// Determines if Vote isclicked.
    /// </summary>
    /// <returns>'true' if clicked; otherwise 'false'</returns>
    /*private static bool VoteClicked()
    {
      return NicamHelper.SafeRequest("VoteButton").Equals("VoteButton");
    }*/

    /// <summary>
    /// Generics the personalization spot link button clicked.
    /// </summary>
    /// <returns>
    /// The personalization spot link button clicked.
    /// </returns>
    private static bool GenericPersonalizationSpotLinkButtonClicked()
    {
      return NicamHelper.SafeRequest("GenericPersonalizationSpotLinkButton").Contains("GenericPersonalizationSpotLinkButton");
    }

    /// <summary>
    /// Adds the component to dealer product group.
    /// </summary>
    /// <param name="componentPath">The component path.</param>
    /// <param name="targetControlName">Name of the target control.</param>
    /*private void AddComponentToDealerProductGroup(string componentPath, string targetControlName)
    {
      if (!string.Equals(Sitecore.Context.GetSiteName(), "dealer") || !Sitecore.Context.Item.IsItemOfType(Consts.ProducGroupTemplateId))
      {
        return;
      }

      this.AddComponent(componentPath, targetControlName);
    }*/

    /// <summary>
    /// Adds the component cart to product on dealer site.
    /// </summary>
    /// <param name="componentPath">The component path.</param>
    /// <param name="targetControlName">Name of the target control.</param>
    /*private void AddComponentToDealerProduct(string componentPath, string targetControlName)
    {
      if (!string.Equals(Sitecore.Context.GetSiteName(), "dealer") || !Sitecore.Context.Item.IsItemOfType(Consts.ProducBaseTemplateId))
      {
        return;
      }

      this.AddComponent(componentPath, targetControlName);
    }*/

    /// <summary>
    /// Adds the component.
    /// </summary>
    /// <param name="componentPath">The component path.</param>
    /// <param name="targetControlName">Name of the target control.</param>
    private void AddComponent(string componentPath, string targetControlName)
    {
      var rightColumn = this.GetControl(this.Page, targetControlName);
      if (rightColumn == null)
      {
        return;
      }

      var temp = new UserControl();
      var ctrl = temp.LoadControl(componentPath);
      Assert.IsNotNull(ctrl, string.Format("Failed to load control '{0}'", componentPath));
      rightColumn.Controls.AddAt(0, ctrl);
    }

    /// <summary>
    /// Gets the control by name.
    /// </summary>
    /// <param name="root">The root control.</param>
    /// <param name="name">The target control name.</param>
    /// <returns>The control.</returns>
    private Control GetControl(Control root, string name)
    {
      var c = root.FindControl(name);
      if (c != null)
      {
        return c;
      }

      foreach (Control control in root.Controls)
      {
        c = this.GetControl(control, name);
        if (c != null)
        {
          return c;
        }
      }

      return null;
    }

    /// <summary>
    /// Rates the page.
    /// </summary>
    /* private void RatePage()
    {
      Item item = Sitecore.Context.Item;
      if (item != null)
      {
        lock (Locking)
        {
          string key = "rate_" + item.ID;
          if (Session[key] != null)
          {
            VoteMembers voteMembers = Session[key] as VoteMembers;
            if (voteMembers != null && !voteMembers.AlreadyVoted)
            {
              NicamHelper.VoteForPage(voteMembers.ID, voteMembers.Voce, voteMembers.Mark);
              voteMembers.AlreadyVoted = true;
            }
          }
        }
      }
    }*/

    /// <summary>
    /// Tracks the generic personalization spot.
    /// </summary>
    private void TrackGenericPersonalizationSpot()
    {
      char[] symbols = { ',' };
      string spotItemId = NicamHelper.SafeRequest("GenericPersonalizationSpotId").TrimEnd(symbols);

      Item spotItem = Sitecore.Context.Database.Items[spotItemId];

      //Perform tracking of spot item
      TrackingFieldProcessor processor = new TrackingFieldProcessor();
      processor.Process(spotItem);

      string gpSpotEvent = NicamHelper.SafeRequest("GenericPersonalizationSpotGoal").TrimEnd(symbols);
      gpSpotEvent = gpSpotEvent.Replace('+', ' ');
      gpSpotEvent = gpSpotEvent.Replace("%2b", " ");
      if (gpSpotEvent != string.Empty)
      {
        var pedata = new PageEventData(gpSpotEvent);
        Tracker.CurrentPage.Register(pedata);
      }

      string redirectUrl = NicamHelper.SafeRequest("GenericPersonalizationSpotRedirectUrl").TrimEnd(symbols);
      Response.Redirect(redirectUrl);
    }

    public string Title
    {
      get
      {
        Item item = Sitecore.Context.Item;
        if (item == null)
        {
          return "Nicam";
        }
        if ((item.Fields[Consts.MenuTitleFieldName] != null) && !string.IsNullOrEmpty(item.Fields[Consts.MenuTitleFieldName].Value))
        {
          return HttpUtility.HtmlEncode(item.Fields[Consts.MenuTitleFieldName].Value);
        }
        return HttpUtility.HtmlEncode(item.DisplayName);
      }

    }
  }
}
