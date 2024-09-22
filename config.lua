Config = {}

Config.Strings = {
    PoliceTag = "Police",
    TrafficWarning = "All traffic on",
    CautionMessage = "is ordered to drive carefully.<br> Thank you for your cooperation and for helping to ensure safety.",
    ZoneRemovedTitle = "Zone Removed",
    ZoneRemovedDescription = "The last speed zone has been removed.",
    ErrorTitle = "Error",
    ErrorDescription = "Failed to remove the speed zone.",
    NoZonesTitle = "No Zones",
    NoZonesDescription = "There are no speed zones to remove.",
    TrafficControlTitle = "Traffic Control",
    StopTrafficTitle = "Stop Traffic",
    StopTrafficDialogTitle = "Stop Traffic",
    ZoneDiameterLabel = "Zone Diameter (m)",
    TrafficStoppedTitle = "Traffic Stopped",
    TrafficStoppedDescription = "Traffic has been stopped in the zone.",
    SlowTrafficTitle = "Slow Traffic",
    SlowTrafficDialogTitle = "Slow Traffic",
    SpeedLabel = "Speed (km/h)",
    TrafficSlowedTitle = "Traffic Slowed",
    TrafficSlowedDescription = "Traffic has been slowed to %d km/h in the zone.",
    ResetZoneTitle = "Reset Zone"
}

Config.UseJob = true

Config.PoliceJob = {
    JobName = 'police'
}

Config.NotifySettings = { 
    position = 'top' -- 'top' or 'top-right' or 'top-left' or 'bottom' or 'bottom-right' or 'bottom-left' or 'center-right' or 'center-left'
}

Config.TrafficControlCommand = {
    CommandName = 'speedzone'
}

Config.TrafficWarningColor = {
    r = 9,
    g = 41,
    b = 69,
    a = 1
}

Config.TrafficBlip  = {
    color = 5, 
    sprite = 9
}