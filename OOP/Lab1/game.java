import java.io.*;
import java.util.*;

class constants 
{
    public static final int UTOWER_DPMUS = 4; 
    public static final int UTOWER_DPMTS = 1;
    public static final int UTOWER_DPMFS = 0;
    public static final int UTOWER_HLVL = 10;
    public static final int UTOWER_SPLVL = 3;

    public static final int TTOWER_DPMUS = 4;
    public static final int TTOWER_DPMTS = 4;
    public static final int TTOWER_DPMFS = 0;
    public static final int TTOWER_HLVL = 10;
    public static final int TTOWER_SPLVL = 1;


    public static final int FTOWER_DPMUS = 0;
    public static final int FTOWER_DPMTS = 0;
    public static final int FTOWER_DPMFS = 4;
    public static final int FTOWER_HLVL = 10;
    public static final int FTOWER_SPLVL = 3;

    public static final int EU_DPUT = 4;
/* other constants */
}

class Position 
{
    private int x, y;

    public void setX(int tx) { x = tx; }
    public int getX() { return x; }
    public void setY(int ty) { y = ty; }
    public int getY() { return y; }

    public Position() 
    {
        setX(0);
        setY(0);
    }
    public Position(int tx, int ty) 
    {
        setX(tx);
        setY(ty);
    }
    public Position(Position pos) 
    {
        setX(pos.getX());
        setY(pos.getY());
    }
}



class Tower 
{
    private static int count = 0;
    private int id;
    private int level;
    private Position position;

    public int getId() { return id; }
    public void setId(int value) { id = value; }
    public int getLevel() { return level; } 
    public void setLevel(int value) { level = value; }
    public Position getPosition() { return position; }


    public Tower(Position pos) 
    {
        position = new Position(pos);
        count++;
        setId(count);
        setLevel(1);
        System.out.format("Tower #%d created successfully!%n", getId());
    }

    protected void finalize() 
    {
        System.out.format("Tower #%d object deleted!%n", getId());
    }
}

class Enemy
{
    private static int count = 0;
    private int id;
    private Position position;
    private int level;

    public int getId() { return id; }
    public void setId(int value) { id = value; }

    public int getLevel() { return level; }
    public void setLevel(int value) { level = value; }


    public Enemy(Position pos)
    {
        count++;
        setId(count);
        setLevel(1);
        position = new Position(pos);
        System.out.format("Enemy #%d created successfully!%n", getId());
    }

    protected void finalize() 
    {
        System.out.format("Enemy #%d object deleted!%n", getId());
    }
}


class UnitTower extends Tower 
{
    private int current_healt;

    public int getHealth() { return current_healt; }
    public void setHealth(int value) { current_healt = value; }
    public void Hit(int value) { setHealth(Math.max(0, getHealth() - value)); }
    public boolean Destroyed() {return getHealth() == 0 ? true : false; }

    public int getSpeed() { return getLevel() * constants.UTOWER_SPLVL; }
    public int getUDamage() { return getLevel() * constants.UTOWER_DPMUS; }
    public int getTDamage() { return getLevel() * constants.UTOWER_DPMTS; }
    public int getFDamage() { return getLevel() * constants.UTOWER_DPMFS; }
    public int getMaxHealth() { return getLevel() * constants.UTOWER_HLVL; }

    public UnitTower(Position pos) 
    {
        super(pos);
        current_healt = getMaxHealth();
    }
   
    public void HitUnit(Unit unit)
    {
        unit.Damage(getUDamage());  
    }

    public void Damage(int damage) 
    {
        Hit(damage);

        if (Destroyed()) 
        {
            System.out.format("Enemy destoyed our Unit Tower($id = %d)%n", getId());
        }
    }
}

class Unit extends Enemy
{
    private int health;
    
    public int getHealth() { return health; }
    public void setHealth(int value) {health = value; }
    public void Hit(int value) { setHealth(Math.max(0, getHealth() - value)); }
    public boolean Died() {return getHealth() == 0 ? true : false; }
    public int getUTDamage() { return getLevel() * constants.EU_DPUT; }

    public Unit(Position pos) 
    {
        super(pos);
        setHealth(getLevel() * 2);
    }

    public void HitUTower(UnitTower tower) 
    {
        tower.Damage(getUTDamage());
    }

    public void Damage(int damage) 
    {
        Hit(damage);

        if (Died()) 
        {
            System.out.format("Tower destoyed Enemy Unit($id = %d)%n", getId());
        }

    }
}



public class game 
{
    public static void main(String[] args) 
    {
        Unit enemy  = new Unit(new Position(5, 5));
        UnitTower tower  = new UnitTower(new Position(5, 5));

        while (!enemy.Died() && !tower.Destroyed()) 
        {
            enemy.HitUTower(tower);
            if (!tower.Destroyed()) 
            {
                tower.HitUnit(enemy);
            }
        }

        if (enemy.Died()) 
        {
            enemy = null;
        }
        if (tower.Destroyed()) 
        {
            tower = null;
        }



        System.gc();

        /* Waiting gc */
        for (int i = 0; i < 2000000; i++) 
        {
            i++;
        }
    }
}
