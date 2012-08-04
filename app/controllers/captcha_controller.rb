require 'digest/md5'

class CaptchaController < ApplicationController
  def new
    if params['want']  == 'verify'
      if params['captcha'].slice(10,params['captcha'].length) == session['captcha_codes'][session['captcha_answer']]
        render :json =>  {'status' => 'success'}
      else
        session['captcha_codes']=nil
        session['captcha_answer']=nil
        render :json =>  {'status' => 'error'}
      end

    elsif params['want']  == 'refresh'
        captchaImages = [ {     'label' => 'star',
          'on'    => {  'top'   => '-120px',
            'left'  => '-3px'},
          'off'   => {  'top'   => '-120px',
            'left'  => '-66px'},
        },
        {   'label' => 'heart',
          'on'    => {  'top'   => '0',
            'left'  => '-3px'},
          'off'   => {  'top'   => '0',
            'left'  => '-66px'},
        },
        { 'label' => 'bwm',
          'on'    => {  'top'   => '-56px',
            'left'  => '-3px'},
          'off'   => {  'top'   => '-56px',
            'left'  => '-66px'},
        },
        { 'label' => 'diamond',
          'on'    => {  'top'   => '-185px',
            'left'  => '-3px'},
          'off'   => {  'top'   => '-185px',
            'left'  => '-66px'}
        } ]

      captcha_codes = {  'star'    =>   Digest::MD5.hexdigest(rand(99999999).to_s),
        'heart'   => Digest::MD5.hexdigest(rand(99999999).to_s),
        'bwm'     => Digest::MD5.hexdigest(rand(99999999).to_s),
        'diamond' => Digest::MD5.hexdigest(rand(99999999).to_s)
      };

      captchaImages.shuffle!

      randomCaptcha = captchaImages.sample

      session['captcha_answer']= randomCaptcha['label'];
      session['captcha_codes']= captcha_codes;

      #HTML output
      div =  '<div class="captchaWrapper" id="captchaWrapper">'
      count = 0
      captchaImages.each do |captchaImage|
        div += '  <a href="#" class="captchaRefresh"></a>
              <div  id="draggable_' + captcha_codes[captchaImage['label']] + '"
                    class="draggable"
                    style="left: ' + ((count * 68) + 15).to_s + 'px; background-position: ' + captchaImage['on']['top'] + ' ' + captchaImage['on']['left'] + ';"></div>'
        count+= 1
      end

      div += '<div class="targetWrapper">
                <div  class="target"  style="background-position: ' + randomCaptcha['off']['top'] + ' '  + randomCaptcha['off']['left'] + ';"></div>
            </div><input type="hidden" class="captcha_answer" name="captcha" value="" /> </div>'
      render :text => div
    else
    end

  end


end