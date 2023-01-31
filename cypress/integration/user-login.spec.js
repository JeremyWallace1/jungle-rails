describe('jungle-rails user_login', () => {
  function makeEmail() {
    const strValues = "abcdefg12345";
    let strEmail = "";
    let strTmp;
    for (let i = 0; i < 10; i++) {
        strTmp = strValues.charAt(Math.round(strValues.length * Math.random()));
        strEmail = strEmail + strTmp;
    }
    strTmp = "";
    strEmail = strEmail + "@";
    for (let j = 0; j < 8; j++) {
        strTmp = strValues.charAt(Math.round(strValues.length * Math.random()));
        strEmail = strEmail + strTmp;
    }
    strEmail = strEmail + ".com"
    return strEmail;
  }

  let randomEmail = makeEmail();

  beforeEach(() => {
    // Cypress starts out with a blank slate for each test
    // so we must tell it to visit our website with the `cy.visit()` command.
    // Since we want to visit the same URL at the start of all our tests,
    // we include it in our beforeEach function so that it runs before each test
    cy.visit('/')
  });
  it('should open signup form when Signup button clicked', () => {
    cy.get('a[href="/signup"]').click();
    cy.get('#user_first_name').should("be.visible");
  });
  it('should create a new user when Signup form is filled out', () => {
    cy.get('a[href="/signup"]').click();
    cy.get('#user_first_name').type('Jeremy');
    cy.get('#user_last_name').type('Wallace');
    cy.get('#user_email').type(randomEmail);
    cy.get('#user_password').type('testing123!');
    cy.get('#user_password_confirmation').type('testing123!');
    cy.get('form').submit();
    cy.get('.nav-link').should('contain.text', 'Signed in as');
  });
  it('should be able to login with email and password credentials of existing user', () => {
    cy.get('a[href="/login"]').click();
    cy.get('#email').type(randomEmail);
    cy.get('#password').type('testing123!');
    cy.get('form').submit();
    cy.get('.nav-link').should('contain.text', 'Signed in as');
  });
  it('should be able to logout when logged in', () => {
    cy.get('a[href="/login"]').click();
    cy.get('#email').type(randomEmail);
    cy.get('#password').type('testing123!');
    cy.get('form').submit();
    cy.get('.nav-link').should('contain.text', 'Signed in as');
    cy.get('a[href="/logout"]').click();
    cy.get('a[href="/login"]').should("be.visible");
  });
  it('should be able to login from any page', () => {
    cy.visit('/products/1')
    cy.get('a[href="/login"]').click();
    cy.get('#email').type(randomEmail);
    cy.get('#password').type('testing123!');
    cy.get('form').submit();
    cy.get('.nav-link').should('contain.text', 'Signed in as');
  })
});