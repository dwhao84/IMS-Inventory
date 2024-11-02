import UIKit
import UIView_Shimmer

class ProductCollectionViewCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    static let identifier: String = "ProductCollectionViewCell"
    
    static func scriptFont(size: CGFloat) -> UIFont {
      guard let customFont = UIFont(name: "NotoIKEATraditionalChinese-Bold", size: size) else {
        return UIFont.systemFont(ofSize: size)
      }
      return customFont
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.backgroundColor = Colors.white
        imageView.tintColor = Colors.black
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let articleNumberLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "Loading..."
        label.textColor = Colors.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.backgroundColor = Colors.black
        label.textAlignment = .center
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productTCNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 2  // 限制最多2行
        label.adjustsFontSizeToFitWidth = true  // 允許字體縮小以適應寬度
        label.minimumScaleFactor = 0.8  // 最小可縮小到原始大小的80%
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productENNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 3  // 允許3行顯示
        label.lineBreakMode = .byTruncatingTail  // 超出時在尾部顯示省略號
        label.adjustsFontSizeToFitWidth = true  // 允許字體縮小以適應寬度
        label.minimumScaleFactor = 0.8  // 最小可縮小到原始大小的80%
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "庫存數: Loading..."
        label.textColor = Colors.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8  // 增加間距讓文字更好閱讀
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        // 添加陰影效果使 cell 更有層次感
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = Colors.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(systemName: "photo.fill")
        productTCNameLabel.text = "Loading..."
        productENNameLabel.text = "Loading..."
        articleNumberLabel.text = "Loading..."
        qtyLabel.text = "庫存數: "
    }
    
    func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(labelStackView)
        configLabelsStackView()
        addConstraints()
    }
    
    func configLabelsStackView() {
        labelStackView.addArrangedSubview(productTCNameLabel)
        labelStackView.addArrangedSubview(productENNameLabel)
        labelStackView.addArrangedSubview(articleNumberLabel)
        labelStackView.addArrangedSubview(qtyLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            // 圖片約束 - 垂直置中
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Stack view 約束 - 垂直置中對齊圖片
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 確保整體高度適中
            labelStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            // 確保 articleNumberLabel 不會太寬
            articleNumberLabel.widthAnchor.constraint(lessThanOrEqualTo: labelStackView.widthAnchor, multiplier: 0.8),
            
            // 確保 TC 和 EN 名稱標籤寬度相同
            productTCNameLabel.widthAnchor.constraint(equalTo: labelStackView.widthAnchor),
            productENNameLabel.widthAnchor.constraint(equalTo: labelStackView.widthAnchor)
        ])
        
        // 確保圖片不會超出 cell 邊界
        productImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16).isActive = true
        productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16).isActive = true
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 170), body: {
    let prodictCollectionViewCell: UICollectionViewCell = ProductCollectionViewCell()
    return prodictCollectionViewCell
})
