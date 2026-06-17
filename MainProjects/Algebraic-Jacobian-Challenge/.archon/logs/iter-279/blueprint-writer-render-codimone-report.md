# Rendering-cleanup report — Albanese_CodimOneExtension.tex (iter-279)

Defect class handled: **`math-delim`** only (directive declared 8 interleaved sites; no
`literal-ref`, no `bare-label`, no `undefined-macro`). All 8 inverted
`$MATH\( prose \)MATH$` blocks found and normalised to `\(MATH\)` math + plain prose
outside. Math content preserved byte-for-byte; only delimiters changed.

## Edits (defect class = math-delim in every case)

1. **L186–187** (def `CodimOneFree`, "Lean encoding scope" prose) —
   `$\eta \in \texttt{f.domain}\(. … \)\mathrm{Order.coheight}$`
   → `\(\eta \in \texttt{f.domain}\). … \(\mathrm{Order.coheight}\)`.

2. **L1685–1686** (thm `codim_one_extension` statement prose) —
   `$\widetilde f \colon X \to Y\(. … \)X\( … \)\mathrm{Dom}(f)$`
   → `\(\widetilde f \colon X \to Y\). … \(X\) … \(\mathrm{Dom}(f)\)`.

3. **L1731–1732** (thm proof, Step 1) —
   `$\eta \in \mathrm{Dom}(f)\(, … \)\eta \in W \subseteq Z(f)\(. … \)1$`
   → `\(\eta \in \mathrm{Dom}(f)\), … \(\eta \in W \subseteq Z(f)\). … \(1\)`.

4. **L1806–1807** (lem `milne_codim1_indeterminacy` statement prose) —
   `$f \colon X \dashrightarrow G\( … \)f\( … \)X$`
   → `\(f \colon X \dashrightarrow G\) … \(f\) … \(X\)`.

5. **L1884–1885** (proof, Sub-step 2) —
   `$x \in \mathrm{Dom}(\varphi)\( … \)(x, x) \in \mathrm{Dom}(\Phi)$`
   → `\(x \in \mathrm{Dom}(\varphi)\) … \((x, x) \in \mathrm{Dom}(\Phi)\)`.

6. **L1894–1895** (proof, Sub-step 3) —
   `$\Phi^\ast(\mathcal O_{G, e}) \subseteq \mathcal O_{X \times X, (x, x)}\( … \)G\( … \)e$`
   → `\(\Phi^\ast(\mathcal O_{G, e}) \subseteq \mathcal O_{X \times X, (x, x)}\) … \(G\) … \(e\)`.

7. **L1928–1931** (proof, Conclusion — two interleaved formulas in one block) —
   `$f_0 \in \Phi^\ast(\mathcal O_{G, e})\( … \)…$` and
   `$\mathrm{supp}(…)\cap \Delta_X\( … \)1\( … \)\Delta_X\(, … \)(x, x)$`
   → both normalised to `\(...\)` math with prose outside.

8. **L2030–2031** (rmk/proof, condition (2)) —
   `$g \in \mathcal O_Y(V)\( … \)\varphi_U^\ast(g) \in K(X)$`
   → `\(g \in \mathcal O_Y(V)\) … \(\varphi_U^\ast(g) \in K(X)\)`.

No `literal-ref` resolved by rewording (none present).

## Verification
- `grep REF` → NONE.
- `grep` for non-comment lines mixing `$` with `\(`/`\)` → NONE remain.
- Every introduced delimiter is `\(...\)`; no new `\cref` was needed (no ref defects).
- Changed NO statement mathematical content, NO `\lean{}`, NO `\label{}`, NO `\uses{}`
  semantics, added/removed NO `\leanok`/`\mathlibok`, added/deleted/reordered NO blocks.

## Left untouched (correctly NOT defects)
- All `$...$` inside `%` comment lines (source quotes — don't render).
- Balanced single-style `$...$` inside lemma **titles** (L612, 1169, 1183, 1196, 1210,
  1319, 1355, 1561) and the `\texttt` bridge note (L2215): these are balanced, single
  delimiter style — not interleaved — and lemma titles are protected statement text.
  Converting them is out of the math-delim defect scope.

## Note
The whole-file `git diff --stat` (≈1554 insertions) reflects **pre-existing uncommitted
working-tree changes** present at session start (file was already `M`), NOT this pass.
My contribution is exactly the 8 delimiter-only edits above.

No unresolved defects.
