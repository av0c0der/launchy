//
//
//  Launchy
//  
//  Created on 27.02.2021
//  
//  

import Foundation

/**
 Detailed infromation about a SpaceX rocket.
 */
struct Rocket: Decodable, Equatable {

    /// Unique identifier of the rocket.
    let id: String

    /// Rocket name.
    let name: String

    /// Brief information about the rocket.
    let description: String

    /// Link to a dedicated Wikipedia page.
    let wikipedia: URL?

    /// Large size image links.
    let flickr_images: [URL]
}
