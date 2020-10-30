# A normal pipeline definition wouldn't need to hide things from its reader.
# But since this is a tour, we want to keep the definition minimal and show
# hepful text on the pipeline instance and not in the definition too.

from inspect import cleandoc

def guide(root):
    """
    Attach helpful messages
    """

    root.doc = cleandoc(
        """
        #### This is the Root Node

        If it's not running, try resetting it.
        The child nodes will rerun automatically if "run" is enabled.

        #### P Q R D E K

        The row of numbers in the **Results** section shows how many children are...

        - **P** ending
        - **Q** ueued
        - **R** eset
        - **D** one
        - **E** rrored
        - **K** illed

        #### Explore the Pipeline Tree

        To check out the other nodes, click in the pane to the left.
        """
    )

       # add this section when the next stop is ready
       # #### Where Am I?
       #
       # This is the first stop on a tour of Conducto.
       #
       # - To see the map, [click here](/docs/tour)
       # - To go to the next one, [click here](/app/sandbox/github/conducto/examples?dir=tour/git&preview_file=pipeline.py)


    root['hello'].doc = cleandoc(
        """
        #### This Node Succeeds

        Use the pencil icon to change the command, then reset the node.

        Once it finishes, select entries in **Timeline** to view each execution.
        """
    )

    root['world'].doc = cleandoc(
        """
        #### This Node Fails

        To understand why: Take a look at **Stderr**.

        Then click "conducto-default" in the **Image** parameter box.

        #### Missing Software

        This node's image is based on [`python:3.8-slim`](https://hub.docker.com/_/python) .
        The command fails because node.js is not in this image.

        To fix it, define [`node:current-alpine`](https://hub.docker.com/_/node") as this node's image.
        """)

       # add this section when the next stop is ready
       # #### Next Steps
       #
       # Next: [clone a git repo](app/sandbox/github/conducto/examples?dir=tour/git&preview_file=pipeline.py)

    return root