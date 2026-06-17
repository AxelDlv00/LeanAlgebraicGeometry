# Blueprint-Writer Directive — AbelianVarietyRigidity.tex: encode the two resolved bridges

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Strategy context (the slice that matters)
This is the committed route-(c) char-free AV-rigidity stack. The geometric heart
`lem:rigidity_eqOn_dense_open` (`\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}`, block at
L150–214) is the sole genuine geometric gap. iter-158 BUILT bridge 1 (the closed-map step, as the
axiom-clean helper `snd_left_isClosedMap`) and reduced the residual to TWO internal sorries:
`hfib` (a pullback-fibre fact) and the agreement equation (bridge 2, slice-constancy on `U`).

This iter, two scoped `mathlib-analogist` consults RESOLVED the Mathlib route for BOTH residual
sorries (reports: `task_results/mathlib-analogist-rigidity-hfib.md`,
`task_results/mathlib-analogist-rigidity-affineconst.md`; persistent rationale in
`analogies/rigidity-hfib.md` and `analogies/rigidity-affineconst.md` — READ THESE before writing).
Your job is to update the chapter so the prover has the concrete, char-free formalization route.

## Required edits

### 1. `lem:rigidity_eqOn_dense_open` block (L150–214) — add the `[IsAlgClosed]` requirement
The Lean signatures of `rigidity_eqOn_dense_open`, `rigidity_core`, and `rigidity_lemma` currently
carry only `[Field kbar]`. The cohomology-free proof of bridge 2 needs the base field to be
**algebraically closed** (`[IsAlgClosed kbar]`): the per-closed-point residue field `κ(y)` is then
`k̄`, so a proper integral slice has `Γ = k̄` and maps to a single point of the affine. The prose
already says "Let $\bar k$ be algebraically closed", but the formal statement does not encode it.
Add a short **formalization note** (a `\noindent\textbf{...}` paragraph inside the lemma block, or
a dedicated remark) stating: the formalization carries `[IsAlgClosed \bar k]` on this lemma and
propagates it to `\cref{thm:rigidity_lemma}` and its core; this is required for the per-slice
field-triviality and is already assumed by the downstream consumers
`prop:morphism_P1_to_AV_constant` and `rigidity_genus0_curve_to_grpScheme` (the variable is named
`kbar`). Do not delete the existing collapse-hypothesis "load-bearing" paragraph — it stays.

### 2. Expand the proof block (L199–214) with a "Formalization notes" addendum — the two bridges
Keep the existing Mumford verbatim `% SOURCE QUOTE PROOF:` and the textbook prose proof unchanged.
APPEND a clearly-marked formalization-notes paragraph (prose, NO Lean tactics, but you MAY name
the Mathlib lemmas as the chosen route) recording how each step is realised in Lean:

- **Bridge 1 (closed map) — BUILT.** The closed-map step "$X$ complete $\Rightarrow p_2$ closed"
  is the axiom-clean helper `snd_left_isClosedMap` (iter-158), via `IsProper.toUniversallyClosed`
  + base change of universal-closedness across the canonical pullback square + `Over.snd_left`
  (the monoidal projection IS `Limits.pullback.snd X.hom Y.hom`). State it is already proven.

- **The fibre fact `hfib` — RESOLVED route.** The non-emptiness of `V` uses that the slice
  $X \times \{y_0\}$ over the $\bar k$-rational point $y_0$ is exactly the image of the slice
  section $s : X \to X \times Y$ (this is the `hfib` step). Record that the formalization proves
  it WITHOUT the residue-field / `Triplet` / `tensor` machinery: it pastes the identity square for
  the section against the canonical pullback square (`IsPullback.of_right`, `IsPullback.of_horiz_isIso`)
  and reads off the fibre with `AlgebraicGeometry.Scheme.Pullback.image_preimage_eq_of_isPullback`
  (the COARSE topological layer of `PullbackCarrier`). Note explicitly that the fine
  `Triplet`/`carrierEquiv`/residue-field route is the WRONG granularity and is to be avoided. This
  step is char-free and needs no `[IsAlgClosed]`.

- **Bridge 2 (slice-constancy / the agreement equation) — RESOLVED route, cohomology-FREE.**
  Record that "proper connected slice into affine $\Rightarrow$ single point, glued to a morphism
  equality on $U$" is realised by the **global-sections + per-closed-point** route, NOT by any
  relative Stein-factorisation / proper-pushforward `f_*\mathcal O = \mathcal O` statement (which
  is a genuine Mathlib gap and must NOT be attempted — route (c) exists precisely to avoid
  cohomology). The concrete stack: per closed point $y \in V$, $\kappa(y) = \bar k$, the slice
  $X_y$ is proper integral so $\Gamma(X_y) = \bar k$ (`isField_of_universallyClosed` +
  `finite_appTop_of_universallyClosed` + alg-closedness kills the finite extension); a map into the
  affine $U_0$ is pinned by its ring map on global sections (`ext_of_isAffine`), so $f$ and
  $\mathtt{retract}\fatsemi f$ agree on each closed slice; closed points are dense in the
  finite-type $U$ (`closure_closedPoints` / Jacobson space), so the agreement globalises to $U$ via
  the reduced-source / separated-target rigidity `ext_of_isDominant_of_isSeparated'` (already used
  by `rigidity_core`). Flag the one genuinely-missing connective: a "morphisms agreeing on a dense
  set of closed points are equal" hom-ext, to be built from these pieces (NOT cohomology). Mark
  this as the residual ~1–2 iter prover task.

### 3. Update the decomposition remark (`rmk:rigidity_lemma_decomposition`, if present near L80–95)
Reflect: bridge 1 is BUILT; both residual sorries now have a concrete char-free Mathlib route; the
`[IsAlgClosed]` requirement; and that the relative-Stein framing is a deliberately-avoided gap.

## Citation discipline
- The Mumford p.43 verbatim quote and the cube/Milne quotes already in the chapter STAY verbatim —
  do not alter them.
- The formalization-notes additions cite **Mathlib lemma names** (project-internal route), not a
  new external source, so they need no `% SOURCE:` block. They are project-bespoke formalization
  guidance. If you find you want to cite Mumford/Milne further, only quote text you read THIS
  session from the local `references/*.pdf` — otherwise do not add a source line.

## Out of scope (do NOT touch)
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed by sync_leanok / review).
- Do NOT edit the theorem-of-the-cube block (L216–242), `prop:morphism_P1_to_AV_constant`, the
  genus-0⟹ℙ¹ remark, or any other chapter.
- Do NOT touch `.lean` files.
- No Lean tactic strings in the prose (naming Mathlib lemmas as the route is fine; tactic code is not).
