This subdirectory is dedicated to code related to distributed processes.
The next goal here is to factor the project into components which can
be run on their own processors cleanly.

<ul>
<li>color foragers may only need a snapshot of the image (environment).</li>
<li>cellular automata (CA) can be computed easily in parts.</li>
<li>finding rules and color regions for CA which 'play nicely' with the image can be explored genetically</li>
</ul>
