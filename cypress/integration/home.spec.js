// <reference types="cypress" />


describe('example to-do app', () => {
  beforeEach(() => {
    // Cypress starts out with a blank slate for each test
    // so we must tell it to visit our website with the `cy.visit()` command.
    // Since we want to visit the same URL at the start of all our tests,
    // we include it in our beforeEach function so that it runs before each test
    cy.visit('/')
  });
  it('should show the home page description', () => {
    // We use the `cy.get()` command to get all elements that match the selector.
    cy.get('.page-header').first().should('contain.text', 'Looking for a way to add some life to your home?');
  });
  it('should show products on the page', () => {
    cy.get(".products article").should("be.visible");
  });
  it('should show 2 products on the page', () => {
    cy.get(".products article").should("have.length", 2);
  });
});
