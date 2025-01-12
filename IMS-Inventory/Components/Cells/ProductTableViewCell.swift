import UIKit
import UIView_Shimmer

class ProductTableViewCell: UITableViewCell, ShimmeringViewProtocol {
    
    static let identifier = "ProductTableViewCell"
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.photoLibrary
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
    
    let productENNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = Colors.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "Qty: Loading..."
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
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
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
        productENNameLabel.text = "Loading..."
        articleNumberLabel.text = "Loading..."
        qtyLabel.text = "Qty: "
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = selected ? Colors.alphaLightGrey : Colors.white
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? Colors.alphaLightGrey : Colors.white
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(labelStackView)
        configLabelsStackView()
        addConstraints()
    }
    
    private func configLabelsStackView() {
        labelStackView.addArrangedSubview(articleNumberLabel)
        labelStackView.addArrangedSubview(productENNameLabel)
        labelStackView.addArrangedSubview(qtyLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalToConstant: 108),
            
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            
            articleNumberLabel.widthAnchor.constraint(lessThanOrEqualTo: labelStackView.widthAnchor, multiplier: 0.8),
            productENNameLabel.widthAnchor.constraint(equalTo: labelStackView.widthAnchor),
            
            productImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

#Preview(traits: .fixedLayout(width: 420, height: 170), body: {
    let cell = ProductTableViewCell(style: .default, reuseIdentifier: ProductTableViewCell.identifier)
    return cell
})
