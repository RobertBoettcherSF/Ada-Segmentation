--  ===========================================================================
--  Package: Image_Segmentation
--  Description: Comprehensive Ada implementation of Image Segmentation algorithms
--               as documented in Wikipedia (Image Processing / Segmentation).
--               Includes Thresholding (Global & Otsu), Clustering (K-Means),
--               Region Growing, Edge Detection (Sobel/Prewitt), and Watershed.
--  ===========================================================================

with Ada.Containers.Vectors;

package Image_Segmentation is

   ---------------------------------------------------------------------------
   -- Custom Data Types & Constraints
   ---------------------------------------------------------------------------

   type Pixel_Intensity is new Natural range 0 .. 255;
   type Pixel_Label     is new Natural;
   
   type Dimension is new Positive;

   type Image_Grid is array (Dimension range <>, Dimension range <>) of Pixel_Intensity;
   type Label_Grid is array (Dimension range <>, Dimension range <>) of Pixel_Label;

   type Pixel_Position is record
      Row : Dimension;
      Col : Dimension;
   end record;

   package Position_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Pixel_Position);

   type Threshold_Mode is (Global_Fixed, Otsu_Automatic);
   type Connectivity_Mode is (Four_Connected, Eight_Connected);

   ---------------------------------------------------------------------------
   -- Exceptions
   ---------------------------------------------------------------------------
   Invalid_Image_Dimensions : exception;
   Invalid_Cluster_Count    : exception;
   Seed_Out_Of_Bounds       : exception;
   Segmentation_Error       : exception;

   ---------------------------------------------------------------------------
   -- Algorithm 1: Thresholding Variants
   ---------------------------------------------------------------------------
   -- Global Fixed Thresholding: Converts grayscale image into binary (0 or 255)
   -- based on user-supplied threshold value.
   procedure Global_Threshold
     (Input     : in  Image_Grid;
      Output    : out Image_Grid;
      Threshold : in  Pixel_Intensity);

   -- Otsu's Automatic Thresholding: Computes optimal threshold by maximizing
   -- inter-class variance (between background and foreground).
   procedure Otsu_Threshold
     (Input            : in  Image_Grid;
      Output           : out Image_Grid;
      Optimal_Threshold: out Pixel_Intensity);

   ---------------------------------------------------------------------------
   -- Algorithm 2: Clustering (K-Means Segmentation)
   ---------------------------------------------------------------------------
   -- K-Means Segmentation: Iteratively groups pixels into K clusters based
   -- on intensity distance.
   type Cluster_Array is array (Positive range <>) of Pixel_Intensity;

   procedure KMeans_Segmentation
     (Input         : in  Image_Grid;
      Labels        : out Label_Grid;
      K             : in  Positive;
      Max_Iter      : in  Positive := 100;
      Centroids_Out : out Cluster_Array);

   ---------------------------------------------------------------------------
   -- Algorithm 3: Region Growing
   ---------------------------------------------------------------------------
   -- Region Growing: Starts from seed points and appends adjacent pixels if
   -- intensity difference is within specified tolerance.
   procedure Region_Growing
     (Input        : in  Image_Grid;
      Labels       : out Label_Grid;
      Seeds        : in  Position_Vectors.Vector;
      Tolerance    : in  Pixel_Intensity;
      Connectivity : in  Connectivity_Mode := Four_Connected);

   ---------------------------------------------------------------------------
   -- Algorithm 4: Edge Detection Based Segmentation
   ---------------------------------------------------------------------------
   type Gradient_Operator is (Sobel, Prewitt);

   -- Edge Detection: Computes gradient magnitude and thresholds to find boundaries.
   procedure Edge_Based_Segmentation
     (Input     : in  Image_Grid;
      Output    : out Image_Grid;
      Op        : in  Gradient_Operator := Sobel;
      Threshold : in  Pixel_Intensity    := 50);

   ---------------------------------------------------------------------------
   -- Algorithm 5: Watershed Transformation
   ---------------------------------------------------------------------------
   -- Topographic Watershed: Identifies catchment basins and watershed lines.
   procedure Watershed_Segmentation
     (Input  : in  Image_Grid;
      Labels : out Label_Grid);

   ---------------------------------------------------------------------------
   -- Helper Functions
   ---------------------------------------------------------------------------
   function Get_Width (Img : Image_Grid) return Natural;
   function Get_Height (Img : Image_Grid) return Natural;
   procedure Validate_Matching_Dimensions (Img1, Img2 : Image_Grid);

end Image_Segmentation;
