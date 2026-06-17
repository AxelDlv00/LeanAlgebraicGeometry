# References

<!-- archon:references-summary -->
<!-- One row per file. Agents append/update rows as they discover what -->
<!-- actually works. The `How to read` column is a LIVING LOG, not a -->
<!-- static cheat-sheet — fill it in the first time you successfully -->
<!-- ingest a file, and correct it if a later attempt finds a better way. -->

## File inventory

| File | Description | How to read (confirmed working) |
| ---- | ----------- | ------------------------------- |
| `standard-conjectures-abelian-fourfolds.pdf` | Ancona, *Standard conjectures for abelian fourfolds* (arXiv:1806.03216v3, 2020), the published article (MR4199442). 57 pages, 13 sections + appendix. Proves the standard conjecture of Hodge type for abelian fourfolds in positive characteristic, and deduces numerical = ℓ-adic homological equivalence for infinitely many ℓ. | `Read` with `pages: "N"` (poppler/pdftoppm present; renders page images). Use a page range for long pulls. |
| `source/fourfolds_2020.tex` | LaTeX source of the same paper (amsart). **Primary source for formalization** — has all theorem/lemma/definition environments with labels. ~174 KB. | `Read` directly, or `sed -n 'A,Bp'`. Section map: §1 Intro (l.251), §2 Conventions (l.369), §3 Std conj Hodge type (l.434), §4 Motive of abelian variety (l.592), §5 Lefschetz classes (l.658), §6 Abelian varieties over finite fields (l.705), §7 Exotic classes (l.827), §8 Orthogonal motives rank 2 (l.999), §9 Quadratic forms (l.1068), §10 p-adic comparison (l.1144), §11 Characterization of p-adic periods (l.1333), §12 Computation of p-adic periods (l.1538), §13 End of proof (l.1788), Appendix Geometric examples (l.1867). |
| `source/fourfolds_2020.bbl` | Bibliography (compiled BibTeX) for the paper. References to Grothendieck, Milne, Clozel, Tate, Fontaine, Jannsen, etc. | `Read` directly. |
| `source.tar` | Original arXiv e-print tarball; `source/` is its extracted contents. | `tar tf source.tar` to list; already extracted to `source/`. |
| `paper-metadata.md` | Provenance note: MR number, title, author (Giuseppe Ancona), arXiv links, brief summary. | `Read`. |
