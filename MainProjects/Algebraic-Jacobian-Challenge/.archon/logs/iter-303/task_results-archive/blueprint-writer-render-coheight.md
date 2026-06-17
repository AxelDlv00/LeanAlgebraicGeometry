# Render-cleanup report — Albanese_CoheightBridge.tex

## Defect class: `math-delim` (interleaved / `$...$`-vs-`\(...\)` normalisation)

Swept the whole file. All 8 `$...$` sites flagged by the doctor were normalised to
`\(...\)` math with prose kept outside the math delimiters. No statement text, `\lean{}`,
`\label{}`, or `\uses{}` semantics were touched; only prose/proof delimiters changed.

### Edits (line → defect → before → after)

1. **L110–111** — interleaved (inverted `$MATH\( prose \)MATH$`). 
   Before: `$\langle z, \, z \in U\rangle\( denotes \)z\( viewed as a point of \)U$`
   After: `\(\langle z, \, z \in U\rangle\) denotes \(z\) viewed as a point of \(U\)`

2. **L133–134** — interleaved. 
   Before: `$a_i \succeq z\( (in the specialisation preorder) is \)z \rightsquigarrow a_i$`
   After: `\(a_i \succeq z\) (in the specialisation preorder) is \(z \rightsquigarrow a_i\)`

3. **L144–145** — interleaved. 
   Before: `$\langle z\rangle = \langle a_0\rangle \prec \cdots \prec \langle a_n\rangle\( in \)U$`
   After: `\(\langle z\rangle = \langle a_0\rangle \prec \cdots \prec \langle a_n\rangle\) in \(U\)`

4. **L196–199** — plain `$...$` flagged on lines also carrying `\(...\)` (two formulae). 
   Before: `$\mathfrak{p} \supsetneq \cdots \supsetneq \mathfrak{q}_n$ ... $\mathfrak{q}_n \subsetneq \cdots \subsetneq \mathfrak{p}$`
   After: `\(\mathfrak{p} \supsetneq \cdots \supsetneq \mathfrak{q}_n\) ... \(\mathfrak{q}_n \subsetneq \cdots \subsetneq \mathfrak{p}\)`

5. **L254–255** — plain `$...$`. 
   Before: `$\mathfrak{p} \subseteq R$`
   After: `\(\mathfrak{p} \subseteq R\)`

6. **L313–314** — plain `$...$`. 
   Before: `$\operatorname{Ring.KrullDimLE}\,1\, \mathcal{O}_{X,z}$`
   After: `\(\operatorname{Ring.KrullDimLE}\,1\, \mathcal{O}_{X,z}\)`

7. **L413–414** — plain `$...$`. 
   Before: `$\operatorname{ringKrullDim}(X.\text{presheaf.stalk}\,z) = \operatorname{coheight}\,z$`
   After: `\(\operatorname{ringKrullDim}(X.\text{presheaf.stalk}\,z) = \operatorname{coheight}\,z\)`

## Verification

- `grep '\$'` → none remaining.
- `grep 'REF'` → none (no `literal-ref` defects in this chapter, as expected).
- Interleave check (`$` adjacent to `\(`/`\)`) → none remaining.
- No `\cref{}` introduced (no literal-ref/bare-label to repair).
- No statement text, `\lean{}`, `\label{}`, `\uses{}`, `\leanok`, or block ordering changed.

## Unresolved

None. All flagged `math-delim` sites resolved.
