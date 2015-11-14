require 'spec_helper'

describe SemanticRange do
  it 'increment versions' do
    # [version, inc, result, identifier]
    [
      ['1.2.3', 'major', '2.0.0'],
      ['1.2.3', 'minor', '1.3.0'],
      ['1.2.3', 'patch', '1.2.4'],
      ['1.2.3tag', 'major', '2.0.0', true],
      ['1.2.3-tag', 'major', '2.0.0'],
      ['1.2.3', 'fake', nil],
      ['1.2.0-0', 'patch', '1.2.0'],
      ['fake', 'major', nil],
      ['1.2.3-4', 'major', '2.0.0'],
      ['1.2.3-4', 'minor', '1.3.0'],
      ['1.2.3-4', 'patch', '1.2.3'],
      ['1.2.3-alpha.0.beta', 'major', '2.0.0'],
      ['1.2.3-alpha.0.beta', 'minor', '1.3.0'],
      ['1.2.3-alpha.0.beta', 'patch', '1.2.3'],
      ['1.2.4', 'prerelease', '1.2.5-0'],
      ['1.2.3-0', 'prerelease', '1.2.3-1'],
      ['1.2.3-alpha.0', 'prerelease', '1.2.3-alpha.1'],
      ['1.2.3-alpha.1', 'prerelease', '1.2.3-alpha.2'],
      ['1.2.3-alpha.2', 'prerelease', '1.2.3-alpha.3'],
      ['1.2.3-alpha.0.beta', 'prerelease', '1.2.3-alpha.1.beta'],
      ['1.2.3-alpha.1.beta', 'prerelease', '1.2.3-alpha.2.beta'],
      ['1.2.3-alpha.2.beta', 'prerelease', '1.2.3-alpha.3.beta'],
      ['1.2.3-alpha.10.0.beta', 'prerelease', '1.2.3-alpha.10.1.beta'],
      ['1.2.3-alpha.10.1.beta', 'prerelease', '1.2.3-alpha.10.2.beta'],
      ['1.2.3-alpha.10.2.beta', 'prerelease', '1.2.3-alpha.10.3.beta'],
      ['1.2.3-alpha.10.beta.0', 'prerelease', '1.2.3-alpha.10.beta.1'],
      ['1.2.3-alpha.10.beta.1', 'prerelease', '1.2.3-alpha.10.beta.2'],
      ['1.2.3-alpha.10.beta.2', 'prerelease', '1.2.3-alpha.10.beta.3'],
      ['1.2.3-alpha.9.beta', 'prerelease', '1.2.3-alpha.10.beta'],
      ['1.2.3-alpha.10.beta', 'prerelease', '1.2.3-alpha.11.beta'],
      ['1.2.3-alpha.11.beta', 'prerelease', '1.2.3-alpha.12.beta'],
      ['1.2.0', 'prepatch', '1.2.1-0'],
      ['1.2.0-1', 'prepatch', '1.2.1-0'],
      ['1.2.0', 'preminor', '1.3.0-0'],
      ['1.2.3-1', 'preminor', '1.3.0-0'],
      ['1.2.0', 'premajor', '2.0.0-0'],
      ['1.2.3-1', 'premajor', '2.0.0-0'],
      ['1.2.0-1', 'minor', '1.2.0'],
      ['1.0.0-1', 'major', '1.0.0'],

      ['1.2.3', 'major', '2.0.0', false, 'dev'],
      ['1.2.3', 'minor', '1.3.0', false, 'dev'],
      ['1.2.3', 'patch', '1.2.4', false, 'dev'],
      ['1.2.3tag', 'major', '2.0.0', true, 'dev'],
      ['1.2.3-tag', 'major', '2.0.0', false, 'dev'],
      ['1.2.3', 'fake', nil, false, 'dev'],
      ['1.2.0-0', 'patch', '1.2.0', false, 'dev'],
      ['fake', 'major', nil, false, 'dev'],
      ['1.2.3-4', 'major', '2.0.0', false, 'dev'],
      ['1.2.3-4', 'minor', '1.3.0', false, 'dev'],
      ['1.2.3-4', 'patch', '1.2.3', false, 'dev'],
      ['1.2.3-alpha.0.beta', 'major', '2.0.0', false, 'dev'],
      ['1.2.3-alpha.0.beta', 'minor', '1.3.0', false, 'dev'],
      ['1.2.3-alpha.0.beta', 'patch', '1.2.3', false, 'dev'],
      ['1.2.4', 'prerelease', '1.2.5-dev.0', false, 'dev'],
      ['1.2.3-0', 'prerelease', '1.2.3-dev.0', false, 'dev'],
      ['1.2.3-alpha.0', 'prerelease', '1.2.3-dev.0', false, 'dev'],
      ['1.2.3-alpha.0', 'prerelease', '1.2.3-alpha.1', false, 'alpha'],
      ['1.2.3-alpha.0.beta', 'prerelease', '1.2.3-dev.0', false, 'dev'],
      ['1.2.3-alpha.0.beta', 'prerelease', '1.2.3-alpha.1.beta', false, 'alpha'],
      ['1.2.3-alpha.10.0.beta', 'prerelease', '1.2.3-dev.0', false, 'dev'],
      ['1.2.3-alpha.10.0.beta', 'prerelease', '1.2.3-alpha.10.1.beta', false, 'alpha'],
      ['1.2.3-alpha.10.1.beta', 'prerelease', '1.2.3-alpha.10.2.beta', false, 'alpha'],
      ['1.2.3-alpha.10.2.beta', 'prerelease', '1.2.3-alpha.10.3.beta', false, 'alpha'],
      ['1.2.3-alpha.10.beta.0', 'prerelease', '1.2.3-dev.0', false, 'dev'],
      ['1.2.3-alpha.10.beta.0', 'prerelease', '1.2.3-alpha.10.beta.1', false, 'alpha'],
      ['1.2.3-alpha.10.beta.1', 'prerelease', '1.2.3-alpha.10.beta.2', false, 'alpha'],
      ['1.2.3-alpha.10.beta.2', 'prerelease', '1.2.3-alpha.10.beta.3', false, 'alpha'],
      ['1.2.3-alpha.9.beta', 'prerelease', '1.2.3-dev.0', false, 'dev'],
      ['1.2.3-alpha.9.beta', 'prerelease', '1.2.3-alpha.10.beta', false, 'alpha'],
      ['1.2.3-alpha.10.beta', 'prerelease', '1.2.3-alpha.11.beta', false, 'alpha'],
      ['1.2.3-alpha.11.beta', 'prerelease', '1.2.3-alpha.12.beta', false, 'alpha'],
      ['1.2.0', 'prepatch', '1.2.1-dev.0', false, 'dev'],
      ['1.2.0-1', 'prepatch', '1.2.1-dev.0', false, 'dev'],
      ['1.2.0', 'preminor', '1.3.0-dev.0', false, 'dev'],
      ['1.2.3-1', 'preminor', '1.3.0-dev.0', false, 'dev'],
      ['1.2.0', 'premajor', '2.0.0-dev.0', false, 'dev'],
      ['1.2.3-1', 'premajor', '2.0.0-dev.0', false, 'dev'],
      ['1.2.0-1', 'minor', '1.2.0', false, 'dev'],
      ['1.0.0-1', 'major', '1.0.0', false, 'dev'],
      ['1.2.3-dev.bar', 'prerelease', '1.2.3-dev.0', false, 'dev']
    ].each do |v|
      pre, what, wanted, loose, id = v
      input = [pre, what, loose, id]
      expect(SemanticRange.increment(*input)).to eq(wanted), "increment(*#{input}) == #{wanted}"

      parsed = SemanticRange.parse(pre, loose)
      if wanted
        parsed.increment!(what, id)
        expect(parsed.version).to eq(wanted), "increment(*#{input}) object version updated"
        expect(parsed.raw).to eq(wanted), "increment(*#{input}) object raw field updated"
      elsif parsed
        expect(SemanticRange.parse(what, id)).to raise_error
      else
        expect(parsed).to eq(nil)
      end
    end
  end
end
