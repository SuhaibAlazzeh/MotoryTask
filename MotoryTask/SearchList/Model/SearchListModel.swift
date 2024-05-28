//
//  SearchListModel.swift
//  MotoryTask
//
//  Created by Suhaib Alazzeh on 26/05/2024.
//

import Foundation

// MARK: - ServicesModelElement
struct ServicesModelElement: Codable {
    var id: String?
    var createdAt, updatedAt: String?
    var width, height: Int?
    var color, blurHash: String?
    var likes: Int?
    var likedByUser: Bool?
    var description: String?
    var user: User?
    var currentUserCollections: [CurrentUserCollection]?
    var urls: Urls?
    var links: ServicesModelLinks?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description, user
        case currentUserCollections = "current_user_collections"
        case urls, links
    }
}

// MARK: - CurrentUserCollection
struct CurrentUserCollection: Codable {
    var id: Int?
    var title: String?
    var publishedAt, lastCollectedAt, updatedAt: Date?
    var coverPhoto, user: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case coverPhoto = "cover_photo"
        case user
    }
}

// MARK: - ServicesModelLinks
struct ServicesModelLinks: Codable {
    var linksSelf, html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Urls
struct Urls: Codable {
    var raw, full, regular, small: String?
    var thumb: String?
}

// MARK: - User
struct User: Codable {
    var id, username, name: String?
    var portfolioURL: String?
    var bio, location: String?
    var totalLikes, totalPhotos, totalCollections: Int?
    var instagramUsername, twitterUsername: String?
    var profileImage: ProfileImage?
    var links: UserLinks?

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case portfolioURL = "portfolio_url"
        case bio, location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case profileImage = "profile_image"
        case links
    }
}

// MARK: - UserLinks
struct UserLinks: Codable {
    var linksSelf, html, photos, likes: String?
    var portfolio: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes, portfolio
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    var small, medium, large: String?
}
