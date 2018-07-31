module CustomUtils
  # utils methods

  def convert_to_loyalty_name_convention(name)
    name.tr('_', ' ').split.map(&:capitalize).join(' ')
  end
end
