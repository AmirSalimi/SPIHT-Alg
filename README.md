# SPIHT-Alg
Implementation of SPIHT Image Compression Algorithm
SPIHT Encoding

The next algorithm we implemented is the SPIHT algorithm.  This algorithm is similar to EZW; however, there are some differences.  The main difference when compared to the EZW algorithm is the definition of the significance.  In this algorithm the coefficients of the wavelet transform are divided into three groups.  The set that a coefficient is assigned to is dependent on the significance of the coefficient and its descendants. These three lists are given as follows: the list of insignificant pixels (LIP), the list of significant pixels (LSP), and the list of insignificant sets (LIS).  The algorithm starts to output the bitstream beginning with the LIP, followed by the LIS after each pass is completed.

Like EZW, we have a tree of coefficients; however, in SPIHT we need to divide them into 4 sets:

Set
Description
0(i, j)
This is the set of coordinates of the offspring’s of the wavelet coefficient at location (i, j).
D(i,j)
The set of all descendants of the coefficient at location(i,j).
H
The set of all root nodes.
L
This is defined as L(i,j)=D(i,j)-O(i,j).
Table 2

A breakdown of this algorithm is shown below:
1.	Initialization:
a.	Compute initial threshold like EZW and, put all root nodes in the LIP, all trees in the LIS, and the LSP is empty at the beginning.
2.	Sorting Pass:
a.	Check significance of all coefficients in the LIP.  If it is found to be significant, output a one, followed by a sign bit.  Then the coefficient is moved to the LSP, and if it is insignificant then the output is zero.
b.	Check significance of all trees in the LIS.
i.	Type D:
1.	If it is significant, output one and encode its children.
2.	If a child is significant, output one followed by a sign bit.  Then add it to the LSP.
3.	If a child is insignificant, output zero and add it to the end of the LIP.
4.	If the child has descendants, then move the tree to the end of the LIS as Type L, otherwise remove it from the LIS.
ii.	 Type L:
1.	If it is significant, output one, add the children to the end of the LIS as Type D and remove the parent’s tree from the LIS.
2.	If it is insignificant, output zero.
3.	Refinement Pass:
a.	The refinement pass is slightly different from EZW. So in this case, we send one refinement bit for each element of the LSP at the end of each pass. Therefore, at the end of pass n, we should send the nth most significant pixel of the element.

4.	Repeat or Stop
a.	The threshold is decreased by a factor of 2 and we return to step two, unless the bit budget has been reached.

