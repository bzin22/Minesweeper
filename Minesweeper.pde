import de.bezier.guido.*;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
int row = 20;
int col = 20;
int totNumBombs = 20;
int realnumbombs = 0;
boolean gameOver = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[20][20];
    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < col; j++)
        {
            buttons[i][j] = new MSButton(i,j);
        }
    }

    setBombs();
}
public void setBombs()
{
    //your code
    int row1 = (int)(Math.random()*20);
    int col1 = (int)(Math.random()*20);
    for (int i = 0; i < totNumBombs; i++)
    {
        row1 = (int)(Math.random()*20);
        col1 = (int)(Math.random()*20);
        if ( bombs.contains( buttons[row1][col1] ) == false )
        {
            bombs.add(buttons[row1][col1]);
            realnumbombs+=1;
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
    if (gameOver == true)
        displayLosingMessage();
}
public boolean isWon()
{
    int cleared=0;


    for (int i = 0; i < row ; i++)
    {
        for (int r = 0; r < col ; r++)
        {
            if (buttons[i][r].clicked == true)
            {
                if( !( bombs.contains(buttons[i][r]) ) )
                {
                    cleared += 1;
                }

            }            
        }
    }
    
    if( cleared == ((col*row)-(realnumbombs)))
    {
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    buttons[9][7].label = "Y";
    buttons[9][8].label = "0";
    buttons[9][9].label = "U";
    buttons[9][10].label = " ";
    buttons[9][11].label = "L";
    buttons[9][12].label = "O";
    buttons[9][13].label = "S";
    buttons[9][14].label = "E";

    buttons[9][7].lose = true;
    buttons[9][8].lose = true;
    buttons[9][9].lose = true;
    buttons[9][10].lose = true;
    buttons[9][11].lose = true;
    buttons[9][12].lose = true;
    buttons[9][13].lose = true;
    buttons[9][14].lose = true;

    for (int i = 0; i < row; i++)
    {
        for (int j = 0; j < col; j++)
        {
            buttons[i][j].clicked = true;
        }
    }
}
public void displayWinningMessage()
{
    buttons[9][7].label = "Y";
    buttons[9][8].label = "0";
    buttons[9][9].label = "U";
    buttons[9][10].label = " ";
    buttons[9][11].label = "W";
    buttons[9][12].label = "I";
    buttons[9][13].label = "N";

    buttons[9][7].win = true;
    buttons[9][8].win = true;
    buttons[9][9].win = true;
    buttons[9][10].win = true;
    buttons[9][11].win = true;
    buttons[9][12].win = true;
    buttons[9][13].win = true;
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    private boolean win, lose;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/col;
        height = 400/row;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        win = false;
        lose = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void mousePressed() 
    {
        clicked = true;
        if ( keyPressed == true || ( mousePressed && (mouseButton == RIGHT) ) )  
        {
            if (marked == false)
            {
                marked = true;
            }
            else if (marked == true)
            {
                marked = false;
                clicked = false;   
            }
        }
        else if(bombs.contains(this))
        {
            gameOver = true;
        }
        else if(countBombs(r,c) > 0)
        {
            label = str( countBombs(r,c) );
        }
        else 
        {
            for (int i = r - 1; i <= r + 1; i++)
            {
                for(int j = c - 1; j <= c + 1; j++)
                {
                    if ( isValid(i,j) )
                    {
                        if ( buttons[i][j].clicked == false )
                        {
                            buttons[i][j].mousePressed();
                        }
                    }
                }
            }
        }
    }

    public void draw () 
    {    
        if (marked)
        {
            fill(0);
        }
        else if( clicked && bombs.contains(this) )
        { 
            fill(255,0,0);
        }
        else if(clicked)
        {
            fill( 200 );
        }
        else 
        {
            fill( 100 );
        }

        if (win == true)
        {
            fill (0,255,0);
        }

        if (lose == true)
        {
            fill (255,0,0);
        }

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for (int i = row - 1; i <= row + 1; i++)
        {
            for(int j = col - 1; j <= col + 1; j++)
            {
                if ( isValid(i,j) )
                {
                    if ( bombs.contains(buttons[i][j]) )
                    {
                        numBombs++;
                    }
                }
            }
        }
        return numBombs;
    }
}