##Regions##

<p>
Here we hope to find aesthetically reasonable<br>
methods of defining computational regions for<br>
blinkylights over images. The goal being to have<br>
different rules effect color regions related to<br>
'the sky' versus 'the mountain'.<br><br>

One strategy includes coarsening the color space<br>
by sorting the present colors into fewer, effectively<br>
creating a 'bitmap' by which the computational regions<br>
can be simplified. This functionality should help<br>
considerably toward finding interesting rule systems<br>
which have delightful effect on the becoming image.<br>

Related is a color sampling problem. The BlinkyLight game<br>
relies on a sense of state which meets the image by recognizing<br>
color distributions as being quiescent, active, or in-active.<br>
The color palettes are derived from the image.

```
f: Image --> HSB, factoring curves in the 'sky' to curves in the 'blues'
o: HSB --> HSB, integrating the clumpy 'blues' into a connected component.
```
</p>
