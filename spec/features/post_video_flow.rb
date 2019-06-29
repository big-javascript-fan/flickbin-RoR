require 'rails_helper'

RSpec.describe "Post Video Flow", type: :feature do
    it "post video with valid url and predefined tag name" do
        password = "123456789"
        u = create(:user, password: password, password_confirmation: password)

        visit "/users/sign_in"

        within "#new_user" do
            fill_in "user_email", with: u.email
            fill_in "user_password", with: u.password
        end
        
        click_button "Log in"

        visit "/videos/new"

        within ".section-video-post-first" do
            fill_in "video[url]", with: "https://www.youtube.com/watch?v=OMmZsSO5OEM"
            click_link_or_button "NEXT STEP"
        end

        within ".section-video-post-secondary" do
            tag = create(:tag)

            fill_in "video[tag_name]", with: tag.title
            first("#video_tag_id", visible: false).set(tag.id)
        end

        find('#post_video').click

        expect(page).to have_content("Your Post is Now Live!")
    end

    it "video post with wrong url pattern" do
        password = "123456789"
        u = create(:user, password: password, password_confirmation: password)

        visit "/users/sign_in"

        within "#new_user" do
            fill_in "user_email", with: u.email
            fill_in "user_password", with: u.password
        end
        
        click_button "Log in"

        visit "/videos/new"

        within ".section-video-post-first" do
            fill_in "video[url]", with: "https://www.youtube.com/watch?v=weiisadf"
        end

        expect(page).to have_css('.button-video.button-video-nextstep.disabled')
    end

    it "video post with new tag name" do
        password = "123456789"
        u = create(:user, password: password, password_confirmation: password)

        visit "/users/sign_in"

        within "#new_user" do
            fill_in "user_email", with: u.email
            fill_in "user_password", with: u.password
        end
        
        click_button "Log in"

        visit "/videos/new"

        within ".section-video-post-first" do
            fill_in "video[url]", with: "https://www.youtube.com/watch?v=OMmZsSO5OEM"
            click_link_or_button "NEXT STEP"
        end

        within ".section-video-post-secondary" do
            fill_in "video_tag_name", with: "newtagname1"
        end

        expect(page).to have_css('.createTagBtn')
    end

    it "video post with new tag name proceed" do
        password = "123456789"
        u = create(:user, password: password, password_confirmation: password)

        visit "/users/sign_in"

        within "#new_user" do
            fill_in "user_email", with: u.email
            fill_in "user_password", with: u.password
        end
        
        click_button "Log in"

        visit "/videos/new"

        within ".section-video-post-first" do
            fill_in "video[url]", with: "https://www.youtube.com/watch?v=OMmZsSO5OEM"
            click_link_or_button "NEXT STEP"
        end

        within ".section-video-post-secondary" do
            fill_in "video_tag_name", with: "newtagname2"
        end
        find('.createTagBtn').click

        find('#post_video').click

        expect(page).to have_content('Your Post is Now Live!')
    end
end
