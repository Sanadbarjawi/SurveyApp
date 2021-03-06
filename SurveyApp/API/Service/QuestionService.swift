//
//  QuestionService.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import Foundation
import Combine

enum ServiceError: Error {
    case urlRequest
    case decode
}

protocol QuestionServiceProtocol {
    func getSurvey() -> AnyPublisher<Survey, Error>
}

final class QuestionService: QuestionServiceProtocol {
  
    func getSurvey() -> AnyPublisher<Survey, Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        return Future<Survey, Error> { [weak self] promise in
            guard let urlRequest = self?.getURLRequest() else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let surveyResponse = try JSONDecoder().decode(Survey.self, from: data)
                    promise(.success(surveyResponse))

                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription,receiveCancel: onCancel)
        .eraseToAnyPublisher()
        
    }
    
    private func getURLRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gist.githubusercontent.com"
        components.path = "/AamirAbro/7abe426f0f01f58140e826b19f020a8b/raw/58eb42d6a2925e066805eb96612ee33718316b7d/KoltinChallenge.json"
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}
