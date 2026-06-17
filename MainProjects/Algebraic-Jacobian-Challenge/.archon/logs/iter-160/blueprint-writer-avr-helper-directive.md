# Blueprint-writer directive — AbelianVarietyRigidity.tex: host the bridge-2 helper

## Chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (the ONLY file you edit).

## Why you are being dispatched
The iter-159 prover extracted bridge 2 of the Rigidity-Lemma chain (the slice-constancy /
agreement equation) into a NEW top-level Lean declaration:

```
AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine
```

This declaration is the **lone residual `sorry`** of the entire Rigidity-Lemma chain. But it has
**no `\lean{}` block** in the chapter. The iter-159 review (lean-vs-blueprint-checker) flagged this
as a **marker-graph laundering vector**: because there is no blueprint environment carrying its
`\lean{}` and no `\uses` edge pointing at it, the `\leanok`-tagged proofs of `thm:rigidity_lemma`
and `lem:rigidity_eqOn_dense_open` render in the dependency graph as fully proven even though they
transitively depend on a `sorry`. This must be fixed BEFORE a prover is sent at the helper.

There is already a `% TODO (plan agent / blueprint-writer)` comment near the top of the chapter
(around L101-107) describing exactly this fix. Execute it.

## The exact Lean signature of the new declaration (for your `\lean{}` block + prose fidelity)
```lean
theorem rigidity_eqOn_saturated_open_to_affine
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (U : (X ⊗ Y).left.Opens)
    (Vset : Set Y.left)
    (_hUV : (U : Set (X ⊗ Y).left) = (snd X Y).left.base ⁻¹' Vset)
    (U₀ : Z.left.Opens) (_hU₀ : IsAffineOpen U₀)
    (_hfU : ∀ u ∈ (U : Set (X ⊗ Y).left), f.left.base u ∈ U₀) :
    U.ι ≫ f.left = U.ι ≫ (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left
```
i.e.: `U` is a `p₂`-saturated open (`U = p₂⁻¹(Vset)`), `U₀ ⊆ Z` is affine, `f` maps `U` into `U₀`;
conclusion: `f` and the collapsed map `retract ≫ f` (`retract = (x,y) ↦ (x₀,y)`) agree on `U` as
scheme morphisms.

## What to write (three precise edits — do NOT touch anything else)

### Edit 1 — NEW lemma block hosting bridge 2
Add a new `\begin{lemma} ... \end{lemma}` block + its `\begin{proof} ... \end{proof}`,
placed immediately AFTER the proof of `lem:rigidity_eqOn_dense_open` (which ends at the
`\end{proof}` around L302) and BEFORE `\section{The theorem of the cube ...}` (L304).

The block must carry:
- `\label{lem:rigidity_eqOn_saturated_open_to_affine}`
- `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}`
- a `\uses{lem:rigidity_eqOn_dense_open}` (it is the bridge-2 obligation OF that lemma's proof)
- prose stating the lemma in the project's notation, matching the Lean signature above
  (saturated open `U = p₂⁻¹(Vset)`, affine `U₀`, `f(U) ⊆ U₀` ⟹ `f` and `retract ≫ f` agree on `U`).

This is NOT new mathematics — the route-B prose ALREADY EXISTS verbatim in the "Formalization
notes ... Bridge 2 (slice-constancy / the agreement equation) — RESOLVED route, cohomology-FREE"
paragraph inside the proof of `lem:rigidity_eqOn_dense_open` (around L280-301). Your job is to
**lift that bridge-2 prose into the new dedicated block's proof** (a `\begin{proof}` whose body is
the route-B argument), so the named obligation has a real home. Structure the proof prose as the
two-step decomposition the prover will formalize:

  1. **Per-closed-slice constancy.** For each closed point `y ∈ Vset`: `κ(y) = k̄`
     (`[IsAlgClosed kbar]`, finite type); the saturated `U` contains the whole fibre `X_y`, so `f`
     maps the proper integral slice `X_y ≅ X` into the affine `U₀`. By
     `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + algebraic closedness,
     `Γ(X_y) = k̄`, so the slice maps to a single `k̄`-point of `U₀` (`ext_of_isAffine`); that point
     is `f(x₀, y)`. Hence `f` and `retract ≫ f` agree at every closed point of `U`.
  2. **Globalisation over dense closed points.** Closed points are dense in the
     locally-of-finite-type `k̄`-scheme `U` (`closure_closedPoints`, Jacobson). Turning "agrees at
     each closed point" into one dominant probe (a dense-range witness over the closed points —
     the coproduct `∐_{x ∈ closedPoints U} Spec κ(x) ⟶ U`) and feeding it to
     `ext_of_isDominant_of_isSeparated'` yields the morphism equality on all of `U`. This
     "dense-closed-points ⟹ hom-ext" connective is the one piece Mathlib does not package directly
     — a small bespoke build, NOT cohomology.

Explicitly record (as prose, not a marker) that the relative Stein-factorisation /
proper-pushforward `f_*𝒪 = 𝒪` framing is a confirmed Mathlib gap and is **deliberately avoided**.

Citation: this is the formalization realization of Mumford's Rigidity-Lemma proof step "for each
`y ∈ V`, the complete variety `X × {y}` gets mapped by `f` into the affine variety `U`, and hence
to a single point of `U`". The verbatim Mumford quote for that step is already present in the
`% SOURCE QUOTE PROOF:` comment above the proof of `lem:rigidity_eqOn_dense_open` (around L226-235);
you MAY reuse it as the `% SOURCE QUOTE PROOF:` for the new block (it is the same source step).
Use `% SOURCE: [Mumford, Abelian Varieties], Rigidity Lemma (Form I.), Ch.~II \S4, book p.~43
(read from references/mumford-abelian-varieties.pdf, PDF page 54)` — same as the parent lemma.
Do NOT invent a new citation. If you judge a fresh verbatim quote is needed and it is not already
in the chapter, you have `references/mumford-abelian-varieties.pdf` available — but the existing
quote covers this step, so reuse is correct.

### Edit 2 — add the `\uses` edge from the parent proof
In the `\begin{proof}` of `lem:rigidity_eqOn_dense_open` (the `\uses{thm:rigidity_lemma}` line
around L237), add `lem:rigidity_eqOn_saturated_open_to_affine` to the `\uses{...}` set, so the
dependency graph records that this proof depends on the (still-`sorry`) bridge-2 helper. This is
what stops the laundering: the graph now shows the transitive dependency on an unproven obligation.

### Edit 3 — refresh the stale decomposition remark
In `rmk:rigidity_lemma_decomposition` (around L161-166), the "Status (iter-159)" sentence currently
reads "The two residual sorries inside `rigidity_eqOn_dense_open` --- the fibre-over-$y_0$ fact and
bridge~2 (slice-constancy on $U$) --- now both have a concrete characteristic-free Mathlib route".
This is now stale: the fibre fact (`hfib`) is CLOSED, and bridge~2 has been EXTRACTED to the named
helper. Rewrite this sentence to state: the fibre-over-`y₀` fact is now **closed** (the coarse
`PullbackCarrier` route), so `rigidity_eqOn_dense_open` is `sorry`-free in its own body; the **one
remaining** obligation of the chain is bridge~2 (slice-constancy), now isolated as the named helper
`\cref{lem:rigidity_eqOn_saturated_open_to_affine}` with its cohomology-free route-B proof. Keep the
`[IsAlgClosed]` and "Stein deliberately avoided" sentences.

## Out of scope (do NOT touch)
- Do NOT add or remove any `\leanok` or `\mathlibok` marker anywhere. Markers are managed by the
  deterministic `sync_leanok` phase and the review agent — not by you.
- Do NOT edit the cube section, `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`,
  or `thm:rigidity_genus0_curve_to_AV` blocks (the deferred scaffolds).
- Do NOT change the statement or proof prose of `lem:rigidity_eqOn_dense_open` beyond adding the
  `\uses` edge (Edit 2). Its bridge-2 paragraph may stay as-is (it now cross-references the new
  block) OR you may trim it to a one-line pointer to the new block — your choice, but do not delete
  the char-free-route rationale outright; if you trim, the rationale must survive in the new block.
- Do NOT edit any other chapter.

## Verification
After editing, confirm: the new block has `\label` + `\lean{}` + `\uses`; the parent proof's
`\uses` includes the new label; the decomposition remark no longer says "two residual sorries".
Report whether any `% SOURCE QUOTE` you added was copied verbatim from
`references/mumford-abelian-varieties.pdf` (vs reused from an existing in-chapter quote).
