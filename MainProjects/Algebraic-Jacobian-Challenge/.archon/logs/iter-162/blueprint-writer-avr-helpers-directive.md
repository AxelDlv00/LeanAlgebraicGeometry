# Blueprint Writer Directive

## Chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Slug
avr-helpers

## Strategy context (the slice that matters)

The committed genus-0 route (route (c)) lives in this chapter. The Rigidity-Lemma chain
(`thm:rigidity_lemma → lem:rigidity_eqOn_dense_open → lem:rigidity_eqOn_saturated_open_to_affine →
{lem:morphism_eq_of_eqAt_closedPoints (proven), lem:rigidity_eqAt_closedPoint_of_proper_into_affine
(residual)}`) is one residual `sorry` from being fully proven. This iter the prover closes the lone
Step-1 residual `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`. Two Lean declarations need
blueprint nodes so the dependency graph reflects the on-disk Lean truthfully.

Your job is TWO additive edits to this chapter. Do NOT rewrite existing blocks, do NOT touch the
already-proven chain lemmas' statements, do NOT touch the "theorem of the cube" section (a separate
future task), do NOT touch any protected signature, and do NOT add or remove any `\leanok` /
`\mathlibok` marker (those are managed by the deterministic sync / review agent — leave all marker
concerns out entirely).

## Edit 1 — add a node for the PROVEN algebraic-core helper `eq_comp_of_isAffine_of_properIntegral`

This resolves the live iter-161 lean-vs-blueprint-checker MAJOR: the reusable, axiom-clean,
substantive Lean helper `AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral` has NO `\lean{}`
node and no `\uses` edge anywhere in the chapter (documentary gap; the chapter even carries a
`% NOTE (iter-161 review)` TODO at the proof of `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`
asking for exactly this). Add a short `\begin{lemma}...\end{lemma}` node, placed immediately BEFORE
`lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (so the `\uses` runs forward), and then wire
that lemma's proof `\uses{}` to the new label.

**The new lemma's mathematical content** (this is a project-bespoke assembly of Mathlib lemmas — it
realizes, cohomology-free, the classical "a global regular function on a proper integral variety over
an algebraically closed field is constant", which is the affine-image step of Mumford's Rigidity
Lemma proof already quoted in this chapter; NO new external source quote is needed — present it as a
project-bespoke lemma, citing in prose that it realizes that classical step):

- **Label:** `lem:eq_comp_of_isAffine_of_properIntegral`.
- **`\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}`**.
- **Statement.** Let $\bar k$ be algebraically closed and $W$ an integral scheme equipped with a
  structure morphism $w \colon W \to \Spec \bar k$ that is universally closed (proper) and locally of
  finite type. Let $g \colon W \to V$ be a morphism into an affine scheme $V$. Then any two
  $\bar k$-points of $W$ — i.e. any two sections $a, b \colon \Spec \bar k \to W$ of $w$ — satisfy
  $a \mathbin{;} g = b \mathbin{;} g$ (`a ≫ g = b ≫ g`).
- **Proof prose.** Because $W$ is integral and $w$ is universally closed, the global sections
  $\Gamma(W, \mathcal O_W)$ form a field (`isField_of_universallyClosed`), and the structure ring map
  $w^\sharp \colon \bar k \to \Gamma(W)$ (i.e. `wk.appTop` after the canonical $\Gamma(\Spec \bar k)
  \cong \bar k$ identification) is integral / module-finite (`finite_appTop_of_universallyClosed`).
  Since $\bar k$ is algebraically closed and $\Gamma(W)$ is a domain finite over it, that map is
  bijective (`IsAlgClosed.ringHom_bijective_of_isIntegral`), so $\Gamma(W) = \bar k$ and $w^\sharp$ is
  an isomorphism — in particular an epimorphism on $\Gamma$. Both sections $a, b$ left-invert
  $w^\sharp$ on global sections, so they induce the same ring map $a^\sharp = b^\sharp$ on
  $\Gamma(W)$ (cancel the epi $w^\sharp$). A morphism into the AFFINE $V$ is pinned by its global-
  sections ring map (`ext_of_isAffine`), so $a \mathbin{;} g = b \mathbin{;} g$.
- **Every hypothesis is load-bearing** (the iter-161 audit confirmed): `IsAlgClosed` collapses the
  finite extension; `IsIntegral`/integral $W$ makes $\Gamma(W)$ a field (else a two-point
  counterexample); `UniversallyClosed` is what makes $\Gamma$ a field (else $\mathbb A^1$ is a
  counterexample); `LocallyOfFiniteType` gives finiteness of $\Gamma$ over $\bar k$; `IsAffine V` is
  what lets `ext_of_isAffine` pin the map. State these in one sentence.

Then add `lem:eq_comp_of_isAffine_of_properIntegral` to the `\uses{}` of the PROOF block of
`lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (it currently has none on its proof). Replace
the existing `% NOTE (iter-161 review) ... PLAN/BLUEPRINT-WRITER TODO: add a ...node` comment block
(at the Step-1 proof) with a one-line note that the node is now added, OR simply delete that TODO
comment since it is resolved.

## Edit 2 — document the retract-integrality fact `IsIntegral X.left` (the lone remaining Step-1 sub-build)

The prover's iter-161 report identifies the single remaining geometric blocker inside
`lem:rigidity_eqAt_closedPoint_of_proper_into_affine`: realising the slice $X_y \cong X$ as proper
INTEGRAL requires `IsIntegral X.left`, which is NOT automatic and must be derived from $X$ being a
retract of the integral product $X \times Y$. The prover will build this as a named top-level helper
this iter. Give it a short blueprint node (a `\begin{lemma}...\end{lemma}`, project-bespoke, NO
external source) so the dependency graph covers it, placed near / before
`lem:rigidity_eqAt_closedPoint_of_proper_into_affine`:

- **Label:** `lem:isIntegral_of_retract_of_integral` (or a clearer name of your choosing; record it).
- Leave the `\lean{...}` cross-ref to the name the prover will use IF you can predict it; otherwise
  state the lemma WITHOUT a `\lean{}` block (a prose lemma the prover will name), and note in a
  `% NOTE:` that the `\lean{}` cross-ref should be filled once the prover lands the helper. Do not
  fabricate a `\lean{}` name.
- **Mathematical content.** Let $X \times Y$ be integral (reduced + irreducible — here it is
  geometrically irreducible and reduced). Suppose $X$ is a retract of $X \times Y$: there is a section
  $s \colon X \to X \times Y$ with $s \mathbin{;} p_1 = \mathbf 1_X$ ($p_1$ the first projection).
  Then $X$ is integral. Proof: $X$ is reduced because $p_1^\sharp \colon \mathcal O_X \to (p_1)_*
  \mathcal O_{X \times Y}$ (equivalently the section's split injection on rings) embeds $\mathcal O_X$
  into the reduced $\mathcal O_{X \times Y}$ (`isReduced_of_injective` on the split-injective ring
  map); $X$ is irreducible because it is the continuous image of the irreducible $X \times Y$ under
  the surjection $p_1$ (a surjection because it has the section $s$; continuous image of an
  irreducible space is irreducible). Reduced + irreducible = integral.
- This is elementary (no external citation); present as a project-bespoke lemma feeding the Step-1
  geometric assembly. Add it to the Step-1 proof's `\uses{}` alongside Edit 1's label.

## Out of scope (do NOT touch)

- The "theorem of the cube" section (§ deferred deep input) — a separate, larger future blueprint
  task; leave it exactly as is.
- The already-proven chain-lemma statement blocks (`thm:rigidity_lemma`, `lem:rigidity_eqOn_dense_open`,
  `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:morphism_eq_of_eqAt_closedPoints`) — do not
  restate or re-sign them.
- All `\leanok` / `\mathlibok` markers — do not add or remove any.
- Protected signatures (none of these chain lemmas is protected, but do not alter signatures).

## Citation discipline reminder

Both new lemmas are project-bespoke (assemblies of existing Mathlib lemmas / elementary topology +
algebra), so they carry NO `% SOURCE:` / `% SOURCE QUOTE:` blocks — they stand on their proof prose
alone, exactly like the existing `lem:morphism_eq_of_eqAt_closedPoints` block. Do not fabricate a
citation. You MAY note in prose that Edit 1's lemma realizes the "proper connected variety into an
affine is a single point" step already quoted verbatim from Mumford elsewhere in the chapter.
