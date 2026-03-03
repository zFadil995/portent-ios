import Foundation

/// Service type enum for Portent.
/// V1: RADARR, SONARR, SABNZBD. Additional types deferred to v2/v3.
enum ServiceType: String, CaseIterable, Codable {
    case radarr = "RADARR"
    case sonarr = "SONARR"
    case sabnzbd = "SABNZBD"
    case lidarr = "LIDARR"
    case readarr = "READARR"
    case prowlarr = "PROWLARR"
    case bazarr = "BAZARR"
    case whisparr = "WHISPARR"
    case overseerr = "OVERSEERR"
    case jellyseerr = "JELLYSEERR"
    case nzbget = "NZBGET"
    case transmission = "TRANSMISSION"
    case qbittorrent = "QBITTORRENT"
    case tautulli = "TAUTULLI"
    case plex = "PLEX"
    case wakeOnLan = "WAKE_ON_LAN"
}
