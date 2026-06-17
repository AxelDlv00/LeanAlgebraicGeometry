# Lean ↔ Blueprint Check Report

## Slug
avr-iter159

## Iteration
159

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Compile / sorry state (verified this iter)
- `lean_diagnostic_messages`: `sorry` warnings at lines **124** (`rigidity_eqOn_saturated_open_to_affine`),
  **453** (`morphism_P1_to_grpScheme_const`), **477** (`genusZero_curve_iso_P1`),
  **502** (`rigidity_genus0_curve_to_grpScheme`). No `failed_dependencies`.
- **No** sorry warning at lines 170 / 337 / 419 → `rigidity_eqOn_dense_open`, `rigidity_core`,
  `rigidity_lemma` are **sorry-free in their own bodies**. The iter-159 prover claim (hfib closed,
  bridge 2 extracted) is accurate.
- `lean_verify rigidity_eqOn_dense_open` axioms = `{propext, sorryAx, Classical.choice, Quot.sound}`.
- `lean_verify rigidity_lemma` axioms = `{propext, sorryAx, Classical.choice, Quot.sound}`.
  → both **transitively depend on `sorryAx`** via the new helper; neither is fully proven.

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (thm:rigidity_lemma)
- **Lean target exists**: yes (line 419).
- **Signature matches**: yes. `[IsAlgClosed kbar]` was added this iter; the chapter documents this
  addition explicitly (lem:rigidity_eqOn_dense_open formalization note, lines 202–213, and
  rmk:rigidity_lemma_decomposition lines 150–159: "the formalization adds `[IsAlgClosed k̄]` to all
  three chain lemmas"). The collapse hypothesis `_hf` and the three varieties-instances
  (`GeometricallyIrreducible`, `IsReduced`, `IsSeparated`) match the prose ("V complete, V×W
  geometrically irreducible, Z separated").
- **Proof follows sketch**: yes (witness `g(y)=f(x₀,y)`, `rigidity_snd_lift` reassoc, then
  `rigidity_core`). Matches the chapter proof body.
- **notes**: proof block carries `\leanok` (line 86) but the declaration is transitively `sorryAx`
  — see Red flags / Q4 below.

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (lem:rigidity_eqOn_dense_open)
- **Lean target exists**: yes (line 170).
- **Signature matches**: yes, including the new `[IsAlgClosed kbar]`. The chapter's "Formalization
  note: the base field is algebraically closed" (lines 202–213) is a precise, current match for the
  added instance. Conclusion shape (∃ nonempty open U on which `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`)
  matches the prose.
- **Proof follows sketch**: yes — Mumford's `U = X × V`, `G = p₂(f⁻¹(Z∖U₀))`, closed-map bridge 1,
  `y₀ ∉ G` via `_hf`. Sorry-free in its own body; the residual is delegated to the helper.
- **notes**: proof block carries `\leanok` (line 227) but the declaration is transitively `sorryAx`.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (prop:morphism_P1_to_AV_constant)
- **Lean target exists**: yes (line 453). **Signature matches**: yes. **Proof follows sketch**: N/A —
  body `sorry`. KNOWN deferred gap (theorem of the cube). Not re-flagged.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (prop:genusZero_curve_iso_P1)
- **Lean target exists**: yes (line 477). **Signature matches**: yes. **Proof follows sketch**: N/A —
  body `sorry`. KNOWN deferred gap (Riemann–Roch). Not re-flagged.

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (thm:rigidity_genus0_curve_to_AV)
- **Lean target exists**: yes (line 502). **Signature matches**: yes (mirrors `rigidity_over_kbar`
  minus `[CharZero]`). **Proof follows sketch**: N/A — body `sorry`. KNOWN deferred gap. Not re-flagged.

## Directive answers

**Q1 — Is there a blueprint block for the new helper `rigidity_eqOn_saturated_open_to_affine`?**
**No.** The string `rigidity_eqOn_saturated_open_to_affine` does not occur anywhere in the chapter.
"Bridge 2 (slice-constancy / the agreement equation)" exists only as *prose embedded inside the proof
block of `lem:rigidity_eqOn_dense_open`* (lines 269–290) — there is no `\lean{...}`-tagged statement
block and no `\uses` edge for the new top-level Lean obligation. The chapter needs a dedicated block;
this is the formal home of the Bridge-2 prose. **Flagged — major** (see consequence under Q4).

**Q2 — Does the `\lean{}` hint for `lem:rigidity_eqOn_dense_open` still match the current signature
after `[IsAlgClosed kbar]` was added?**
**Yes.** `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` resolves to the existing declaration, and
the chapter explicitly documents the `[IsAlgClosed k̄]` addition and its propagation to
`rigidity_lemma`/`rigidity_core` (lines 202–213, 150–159). Hint and signature are consistent.

**Q3 — Is the helper statement faithful to the Bridge-2 prose ("proper slice into affine ⟹ constant
in the X-direction")?**
**Yes.** `rigidity_eqOn_saturated_open_to_affine` states: on a `p₂`-saturated open `U = (snd).base⁻¹(Vset)`
where `f` lands in a single affine `U₀`, `f` agrees with the collapse `retract ≫ f` on `U`
(`U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`). That is precisely the prose's "proper slice into affine ⟹
f depends only on Y ⟹ agrees with the collapsed map", with the affine-containment (`_hfU`), saturation
(`_hUV`), and affineness (`_hU₀`) hypotheses faithfully encoded. The instance set
(`IsProper X.hom`, `GeometricallyIrreducible`, `IsReduced`, `IsSeparated`, `IsAlgClosed`) matches the
chain. No mathematical divergence.

**Q4 — No laundering?**
**Prose: clean.** The chapter never claims the chain is fully proven. The iter-159 status remark
(rmk:rigidity_lemma_decomposition) and the dense-open formalization notes explicitly label bridge 2
"the residual ∼1–2 iteration prover task", and the iter-158 `% NOTE` (lines 87–96) states "honest
transitive sorry, no custom axiom". This is consistent with the verified `sorryAx` on both
`rigidity_eqOn_dense_open` and `rigidity_lemma`.

**Marker/graph-level: laundering RISK, tied to Q1.** The proof blocks of `thm:rigidity_lemma` (line 86)
and `lem:rigidity_eqOn_dense_open` (line 227) carry `\leanok` ("proof closed, no sorry"). Because the
new helper has **no blueprint block** (Q1), the dependency graph has **no `\uses` edge** representing
that these two transitively rest on an open `sorry`. Consequence: the rendered blueprint will color
`rigidity_lemma` / `rigidity_eqOn_dense_open` as fully proven, contradicting their verified `sorryAx`.
`\leanok` is owned by the deterministic `sync_leanok` / the review agent, not by this checker — I flag
it rather than judge whether sync should have removed it. Adding the helper block with a `\uses` edge
from the dense-open proof is what makes the graph honest.

## Red flags

### Placeholder / suspect bodies
- `rigidity_eqOn_saturated_open_to_affine` (line 124): body `:= sorry`. This is the prover's
  deliberately-isolated bridge-2 obligation; **expected** for iter-159, but it currently has **no
  `\lean{}` block** in the chapter (Q1). A `sorry` declaration with no blueprint home is the laundering
  surface — must get a block so the graph tracks it.
- Lines 453 / 477 / 502: `sorry` on the three KNOWN deferred scaffolds. Not re-reported per directive.

### Stale prose (now contradicts the iter-159 structure)
- Line 152–153 (rmk:rigidity_lemma_decomposition, iter-159 status): "The two residual sorries inside
  `rigidity_eqOn_dense_open`". **Stale/incorrect**: after iter-159 there is exactly **one** residual
  `sorry`, and it has been **extracted out** of `rigidity_eqOn_dense_open` into the named helper, so
  **zero** sorries remain "inside" dense_open. Misstates both count and location.
- Lines 93–95 (iter-158 `% NOTE`): "the residual content is the two TRUE-as-stated sorries inside
  rigidity_eqOn_dense_open (the pullback-fibre fact hfib ... and bridge 2 ...)". Stale: `hfib` is now
  closed and bridge 2 is now the lone sorry in the extracted helper. (A `% NOTE` is review-agent
  domain; flag for refresh.)

### Axioms / Classical.choice on non-trivial claims
- None beyond the standard `{propext, Classical.choice, Quot.sound}` + honest `sorryAx`. No custom
  `axiom` declarations in the file.

## Unreferenced declarations (informational)
- `rigidity_snd_lift` (line 66) — helper, proven, no `\lean{}` block. Named in
  rmk:rigidity_lemma_decomposition. Acceptable (cartesian-monoidal algebra helper).
- `snd_left_isClosedMap` (line 85) — helper, proven (bridge 1), no `\lean{}` block. Named with `\texttt`
  in the dense-open notes ("BUILT"). Acceptable; could be promoted to a block (minor).
- `rigidity_core` (line 337) — substantive scheme-level gluing step, no `\lean{}` block. Named in
  rmk:rigidity_lemma_decomposition. Acceptable as documented helper, but it is the most substantial
  unreferenced declaration; worth a block (minor).
- `rigidity_eqOn_saturated_open_to_affine` (line 124) — **the new top-level obligation, NO block** —
  this one is NOT a mere helper; it is the lone open `sorry` of the chain and must be referenced
  (see Q1 / major).

## Blueprint adequacy for this file
- **Coverage**: 5/9 declarations have a `\lean{...}` block. Of the 4 unreferenced: 2 are acceptable
  helpers (`rigidity_snd_lift`, `snd_left_isClosedMap`), 1 is a substantive-but-documented helper
  (`rigidity_core`, minor), and **1 is the open obligation `rigidity_eqOn_saturated_open_to_affine`
  with no block (major)**.
- **Proof-sketch depth**: adequate. Bridge 2's char-free route (per-closed-point κ(y)=k̄ →
  `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` → `ext_of_isAffine` →
  globalise via `closure_closedPoints` + `ext_of_isDominant_of_isSeparated'`) is spelled out in
  detail (lines 269–290) and matches the helper's docstring. A prover could formalize the helper from
  this prose. (The Stein-factorisation avoidance is explicitly stated, consistent with the Lean.)
- **Hint precision**: precise for the 5 referenced blocks (including the `[IsAlgClosed]` update). The
  gap is a *missing* hint, not a wrong one.
- **Generality**: matches need.
- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. **Add a `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` statement block**
     (e.g. `lem:rigidity_eqOn_saturated_open_to_affine`) hosting the existing Bridge-2 prose, and add
     a `\uses{...}` edge from `lem:rigidity_eqOn_dense_open`'s proof to it. This closes the laundering
     gap so the dependency graph stops coloring `rigidity_lemma` green.
  2. Refresh the stale "two residual sorries inside `rigidity_eqOn_dense_open`" wording (rmk lines
     152–153 and `% NOTE` lines 93–95) to "one residual sorry, extracted to the named helper
     `rigidity_eqOn_saturated_open_to_affine`".
  3. (Minor) Consider blocks for `rigidity_core` and `snd_left_isClosedMap`.

## Severity summary
- **must-fix-this-iter**: none. (Prose is honest about the open obligation; helper signature is
  faithful; no signature mismatch, no excuse-comment on a "real" claim, no custom axiom, no
  weakened-wrong definition; the bridge-2 prose is detailed enough to have guided the helper.)
- **major**:
  - Missing `\lean{...}` block for the new top-level obligation
    `rigidity_eqOn_saturated_open_to_affine` (Q1). Its absence breaks the dependency graph so that
    `\leanok`-tagged `rigidity_lemma` / `rigidity_eqOn_dense_open` will render as fully proven despite
    a verified transitive `sorryAx` (Q4 laundering vector).
  - Stale status prose (rmk lines 152–153) that misstates the count and location of the residual
    sorry post-extraction.
- **minor**: `% NOTE` (lines 93–95) stale; `rigidity_core` / `snd_left_isClosedMap` worth promoting to
  blocks.

Overall verdict: Lean side is sound and faithful — the chain lemmas are genuinely sorry-free in their
own bodies with the bridge-2 obligation cleanly isolated and faithfully stated — but the chapter has
**no blueprint block for that new obligation**, which both leaves Bridge 2 without a formal home and
lets the `\leanok`-tagged dense-open / rigidity_lemma proofs appear fully proven while transitively
carrying `sorryAx` (major, chapter-side fix).
