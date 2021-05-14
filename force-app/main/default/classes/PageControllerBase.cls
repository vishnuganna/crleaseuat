public virtual class PageControllerBase {

    private ComponentControllerBase myComponentController;

    public virtual ComponentControllerBase getMyComponentController() {
        return myComponentController;
    }

    public virtual void setComponentController(ComponentControllerBase compController) {
        myComponentController = compController;
    }

    public virtual PageControllerBase getThis() {
        return this;
    }

    /*public virtual PageReference saveLead() {
        return null;
    }*/
}