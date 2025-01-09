# ScrapeSearch
Coding challenge demonstrating a Google web and image search without using the standard API in a Swift and UIKit app. 

## Challenge Parameters
Without using an official Google Search API, create an iOS UIKit app that allows a user perform a Google web and image search, scrapes the data from the webpage and lists the results for the user.

Requirements:
- Allow user to save the image to their device
- Display image in full screen view on tap
- Paginate image and web search results

## Implementation
One of the main challenges with scraping Google data is that their page structure and class names change quite often so building an HTMLDecoder to handle as many cases as possible was a bit of a challenge. Several attempts were made to perform the search and scrape the data. 

1. A URLSession data task to perform a request with the bare minimum parameters. In this implementation, you can seen an example of using dependency injection.  However, image data is not inserted into their respective `img` tags until after the pages are rendered, so this solution was unusable for image searches.
2. Attempting to render the HTML by passing the retrieved string through a UIWebView to run the javascript and process the image data into their respective tags was also unsuccessful. It was however, useful for loading pre-rendered test data, which helped with more performative testing. 
3. Passing the request through the UIWebView to render the HTML and then retrieving the evaluated javascript was the final, although, less performative solution. But by changing the user-agent to an older version, the app retrieves a simpler version of the search results, which allowed for easier decoding, 

Due to time constraints, the app does not get the full resolution image for saving. The app saves the thumbnail image to demonstrate proficiency with device permissions, etc. 
 
