import Foundation

/// Brand name for each service type. These are product identifiers — not localized.
/// Use as a UI fallback when a ServiceInstance has no user-defined name.
extension ServiceType {
    var defaultDisplayName: String {
        switch self {
        case .radarr:       return "Radarr"
        case .sonarr:       return "Sonarr"
        case .sabnzbd:      return "SABnzbd"
        case .lidarr:       return "Lidarr"
        case .readarr:      return "Readarr"
        case .prowlarr:     return "Prowlarr"
        case .bazarr:       return "Bazarr"
        case .whisparr:     return "Whisparr"
        case .overseerr:    return "Overseerr"
        case .jellyseerr:   return "Jellyseerr"
        case .nzbget:       return "NZBGet"
        case .transmission: return "Transmission"
        case .qbittorrent:  return "qBittorrent"
        case .tautulli:     return "Tautulli"
        case .plex:         return "Plex"
        case .wakeOnLan:    return "Wake-on-LAN"
        }
    }
}
