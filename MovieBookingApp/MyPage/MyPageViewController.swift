import UIKit

class MyPageViewController: UIViewController {
    
    private let myPageView = MyPageView()
    private let viewModel = MyPageViewModel()
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        myPageView.bookingCollectionView.dataSource = self
        myPageView.wantedMoviesCollectionView.dataSource = self
        fetchData()
    }
    
    private func setupBindings() {
        myPageView.editNameButton.addTarget(self, action: #selector(editName), for: .touchUpInside)
        myPageView.editEmailButton.addTarget(self, action: #selector(editEmail), for: .touchUpInside)
        myPageView.editPasswordButton.addTarget(self, action: #selector(editPassword), for: .touchUpInside)
    }
    
    @objc private func editName() {
        // 이름 편집 로직
    }
    
    @objc private func editEmail() {
        // 이메일 편집 로직
    }
    
    @objc private func editPassword() {
        // 비밀번호 편집 로직
    }
    
    private func fetchData() {
        viewModel.fetchBookedMovies {
            DispatchQueue.main.async {
                self.myPageView.bookingCollectionView.reloadData()
            }
        }
        viewModel.fetchWantedMovies {
            DispatchQueue.main.async {
                self.myPageView.wantedMoviesCollectionView.reloadData()
            }
        }
    }
}

extension MyPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == myPageView.bookingCollectionView {
            return viewModel.bookedMovies.count
        } else {
            return viewModel.wantedMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
        if collectionView == myPageView.bookingCollectionView {
            let movie = viewModel.bookedMovies[indexPath.item]
            cell.configure(with: movie)
        } else {
            let movie = viewModel.wantedMovies[indexPath.item]
            cell.configure(with: movie)
        }
        return cell
    }
}
