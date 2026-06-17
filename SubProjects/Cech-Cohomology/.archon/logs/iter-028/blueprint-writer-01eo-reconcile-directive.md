# Blueprint-writer directive — reconcile the 01EO chapter with the landed Lean + scaffold L3/L4/top

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(the consolidated chapter; its `% archon:covers` block at lines 3–10 covers both
`AbsoluteCohomology.lean` and `CechToCohomology.lean`).

## Strategy context (the slice that matters)
The 01EO "Čech-to-cohomology comparison on a basis" chain was decomposed last iter into
L1 → L2 → L3 → L4 → top. **L1 and L2 have now LANDED in Lean** (axiom-clean), but in a
**cover-local, presheaf-level, hypothesis-driven** form that is strictly more general than — and
does not match — the cover-global `(B, Cov)` / sheaf prose currently in the chapter. L3/L4/top are
**not yet formalized** (they are this iter's prover target). Absolute cohomology `H^p(U,F)` is the
Form-B Ext realization `Ext^p(jShriekOU U, F)` already built in `AbsoluteCohomology.lean`; the
naturality of `H^0 ≅ Γ` in the coefficient sheaf (`lem:absolute_cohomology_zero_natural`) also landed
last iter. Your job is to make the chapter prose faithfully describe the landed L1/L2, give the
uncovered helpers blueprint entries, and scaffold the L3/L4/top + per-face-SES blocks at the exact
signatures the prover will formalize, so the chapter is a complete, formalize-ready source of truth.

Do **NOT** touch any `\leanok` marker (managed by the deterministic sync). You MAY add `\mathlibok`
**only** on genuine Mathlib dependency anchors (see item 7). All existing `% SOURCE QUOTE` /
`% SOURCE QUOTE PROOF` verbatim blocks MUST be preserved verbatim — you are rewriting the visible
project-notation prose around them, not the quotes.

---

## TASK 1 (must-fix) — Rewrite `lem:cech_ses_of_basis` (L1) statement prose to the landed cover-local form
Current prose (lines ~3232–3246) describes the cover-global `(B,Cov)` / `O_X`-module (sheaf) form.
The **landed Lean signature** is:
```lean
theorem cechComplex_shortExact_of_basis {ι : Type u}
    (U : ι → TopologicalSpace.Opens X)
    (P : ShortComplex X.PresheafOfModules)
    (hface : ∀ (p : ℕ) (σ : Fin (p + 1) → ι), (faceShortComplex U P σ).ShortExact) :
    (sectionCechComplexShortComplex U P).ShortExact
```
Rewrite the statement to: fix an index family `U : ι → Opens X`, a short complex `P` of **presheaves
of `O_X`-modules**, and assume the per-face section short complex `faceShortComplex U P σ` (the short
complex `P.X₁(V_σ) → P.X₂(V_σ) → P.X₃(V_σ)` over `V_σ = ⨅ₖ U(σ k)`) is short exact for every degree `p`
and tuple `σ : Fin(p+1) → ι`. Conclude the induced sequence of section Čech complexes
`sectionCechComplexShortComplex U P` is short exact (as complexes of abelian groups). Keep the
`\uses{def:cech_complex, lem:ses_cech_h1}` and the verbatim source quote. Add a remark: the `(B,Cov)`
instantiation discharges `hface` via the per-face SES derivation of TASK 6 (which uses `ses_cech_h1`
for surjectivity + section left-exactness for the rest). Update the proof block prose to the
degreewise-product argument actually used: `HomologicalComplex.shortExact_of_degreewise_shortExact`
reduces to each degree, where the degree-`p` short complex is the `Pi.map` of the face short complexes,
short-exact by the product-of-SES lemma of TASK 3. Remove the `% NOTE (iter-027 review)` line once the
prose matches (it has served its purpose).

## TASK 2 (must-fix) — Rewrite `lem:quotient_vanishing_cech` (L2) statement prose to the landed form
Current prose (lines ~3291–3296) assumes "`I` injective" in the cover-global frame. The **landed Lean
signature** is:
```lean
theorem quotient_cech_vanishing_of_basis {ι : Type u}
    (U : ι → TopologicalSpace.Opens X) (P : ShortComplex X.PresheafOfModules)
    (hSES : (sectionCechComplexShortComplex U P).ShortExact)
    (hI : ∀ p, 0 < p → IsZero (cechCohomology U P.X₂ p))
    (hF : ∀ p, 0 < p → IsZero (cechCohomology U P.X₁ p)) :
    ∀ p, 0 < p → IsZero (cechCohomology U P.X₃ p)
```
Rewrite the statement: with `U`, `P` as in L1, given the SES of section Čech complexes `hSES` (the L1
output) and the positive-degree Čech-cohomology vanishing of the middle term `P.X₂` (`hI`) and the
left term `P.X₁` (`hF`), conclude the right term `P.X₃` has vanishing positive Čech cohomology. Note in
the prose that at instantiation `hI` is supplied by `injective_cech_acyclic` (`P.X₂ = I` injective) and
`hF` by condition (3) for `F = P.X₁`. Keep the verbatim quote and
`\uses{def:cech_complex, lem:cech_ses_of_basis, lem:injective_cech_acyclic}`. Update the proof prose to
the homology-LES `δIso` dimension-shift argument actually used (it factors through the abstract lemma of
TASK 4). Remove the `% NOTE (iter-027 review)` line once matched.

## TASK 3 (major) — Add a lemma block for `shortExact_piMap` (the AB4* content)
New `\begin{lemma}` block, label `lem:short_exact_pi_map`,
`\lean{AlgebraicGeometry.shortExact_piMap}`, bundling the private helper into its `\lean{}` list:
`\lean{AlgebraicGeometry.shortExact_piMap, AlgebraicGeometry.pi_π_map_apply}`.
Statement: a product (indexed by an arbitrary type) of short exact sequences in `Ab` is short exact —
i.e. for a family of short-exact short complexes `S j`, the short complex with maps `Pi.map (S ·).f`
and `Pi.map (S ·).g` is short exact. This is the AB4* exactness-of-products property of `Ab`. Place it
just before the L1 block (it is L1's degreewise engine). One-line informal proof: mono of the product
map is automatic (products preserve monos); the product of the `Function.Exact` middles is exact
componentwise; the **epi half is the non-trivial point** — `Epi (Pi.map φ)` is NOT a typeclass instance
in `Ab`, it is proved elementwise by choosing, for a target tuple, a componentwise preimage via the
surjectivity of each `(S j).g` and assembling through `Concrete.productEquiv`. Cite this as the
project's AB4* lemma (Archon-original infrastructure; no external source line needed, OR cite Stacks
`homology` AB axioms if you find a clean tag — do NOT fabricate a quote).
`\uses{}` may be empty or reference only `def:cech_complex` if helpful.

## TASK 4 (major) — Add a lemma block for `cechHomology_quotient_vanishing`
New `\begin{lemma}` block, label `lem:cech_homology_quotient_vanishing`,
`\lean{AlgebraicGeometry.cechHomology_quotient_vanishing}`. Statement (abstract homological core of L2,
NOT tied to section Čech): given a short exact sequence `T` of cochain complexes (`ComplexShape.up ℕ`)
in `Ab` with `T.X₂` and `T.X₁` having vanishing positive homology, the third term `T.X₃` has vanishing
positive homology. One-line proof: the homology long exact sequence's connecting isomorphism
(`ShortExact.δIso` / `HomologicalComplex.HomologySequence.δIso`) gives
`T.X₃.homology p ≅ T.X₁.homology (p+1) = 0` for `p > 0`. Mark the δIso step's reliance on Mathlib via a
`\mathlibok` **anchor** block (see TASK 7) if not already present — but the lemma itself is project-proved
(no `\mathlibok` on `lem:cech_homology_quotient_vanishing`). Place it just before the L2 block. Wire
L2's statement `\uses` to include `lem:cech_homology_quotient_vanishing`.

## TASK 5 (coverage) — Give the remaining `CechToCohomology.lean` helpers blueprint entries
These Lean decls are currently `unmatched` (no blueprint entry). Either add a thin
`\begin{definition}` block for each, or bundle into the `\lean{}` list of the lemma that introduces it —
your choice, but `archon dag-query unmatched` must drop to 0 for them:
- `cechCohomology` — the accessor `Ȟ^p(𝒰,F) := (sectionCechComplex U F).homology p`. Give it a short
  `\begin{definition}` block `def:cech_cohomology_accessor`, `\lean{AlgebraicGeometry.cechCohomology}`,
  `\uses{def:section_cech_complex}` (or the correct existing label for the section Čech complex). It is
  referenced by the L2 / L4 signatures.
- `sectionCechComplexShortComplex` — `\begin{definition}` `def:section_cech_short_complex`,
  `\lean{AlgebraicGeometry.sectionCechComplexShortComplex}`, the short complex `0→Č(P.X₁)→Č(P.X₂)→Č(P.X₃)→0`.
  Referenced by L1's conclusion and L2's input.
- `faceShortComplex` — bundle into the L1 block's `\lean{}` list
  (`\lean{AlgebraicGeometry.cechComplex_shortExact_of_basis, AlgebraicGeometry.faceShortComplex}`), or a
  thin def block `def:face_short_complex`. It is the per-`(p,σ)` section short complex.
- The four functoriality helpers `sectionCechCosimplicialMap`, `sectionCechCosimplicialFunctor`,
  `sectionCechComplexFunctor`, `sectionCechComplexMap` — bundle all four into ONE thin
  `\begin{definition}` block `def:section_cech_functoriality`,
  `\lean{AlgebraicGeometry.sectionCechCosimplicialMap, AlgebraicGeometry.sectionCechCosimplicialFunctor,
  AlgebraicGeometry.sectionCechComplexFunctor, AlgebraicGeometry.sectionCechComplexMap}`,
  describing the functorial action of `φ : F ⟶ G` on the section Čech complex (cosimplicial morphism →
  packaged functor → chain map). `\uses{def:section_cech_complex}`.

## TASK 6 (design) — Add the per-face SES derivation sub-lemma (the geometric bridge L1/L4 need)
New `\begin{lemma}` block, label `lem:face_ses_of_sheaf_ses`, `\lean{}` left as a TODO placeholder pin
the prover will create (use `\lean{AlgebraicGeometry.faceShortComplex_shortExact_of_sheaf_ses}` as the
proposed name; mark with a `% NOTE: target not yet formalized — scaffold this iter`). Statement: given a
short exact sequence `S : ShortComplex X.Modules` of **sheaves** of `O_X`-modules with `S.ShortExact`,
an index family `U : ι → Opens X`, and the basis-surjectivity datum from `ses_cech_h1` (section
surjectivity `S.X₂(V) ↠ S.X₃(V)` on every face `V = ⨅ₖ U(σ k)`), the per-face presheaf short complex
`faceShortComplex U (S.map toPresheafOfModules) σ` is short exact for every `p, σ`. Informal proof:
mono and middle-exactness come from **left-exactness of the sections functor** —
`toPresheafOfModules X` is a right adjoint (so preserves finite limits) and evaluation-at-`op V`
preserves limits, hence the section short complex is left-exact; the `Epi`/surjectivity is exactly the
`ses_cech_h1` output at `V`. This lemma produces the `hface` hypothesis that L1 consumes, and is what L4
invokes to instantiate L1/L2 from a genuine sheaf SES. `\uses{lem:ses_cech_h1, def:face_short_complex}`.
Cite Stacks 01EO's "`0 → F(U) → I(U) → Q(U) → 0` exact" step (verbatim quote already in the chapter at
the L1 block — reuse/reference it; do not invent a new quote).

## TASK 7 (design) — Scaffold the `BasisCovSystem` / `HasVanishingHigherCech` encoding + reconcile L3/L4/top
The effort-breaker fixed the L3/L4/top signatures (report:
`.archon/logs/iter-027/effort-breaker-split-01eo-report.md`, lines 62–92). Reflect them in the chapter:

- **`def:basis_cov_system`** — a `\begin{definition}` block for `BasisCovSystem X`: a basis `B : Set (Opens X)`,
  an admissible cover set `Cov`, the faces-in-basis condition (01EO condition (1)), and the cofinality
  condition (01EO condition (2)). `\lean{AlgebraicGeometry.BasisCovSystem}` (proposed; `% NOTE: not yet
  formalized — scaffold this iter`). This is the lightweight record encoding conditions (1)+(2); NO
  colimit machinery.
- **`def:has_vanishing_higher_cech`** — a `\begin{definition}` block for the **abstract** per-module
  predicate `HasVanishingHigherCech s F := ∀ c ∈ s.Cov, ∀ p > 0, IsZero (cechCohomology (cover c) F p)`.
  `\lean{AlgebraicGeometry.HasVanishingHigherCech}` (proposed; same `% NOTE`). **Emphasize in the prose
  that this predicate must stay abstract — `Q = I/F` need NOT be quasi-coherent, so the inductive class
  is "modules with vanishing higher Čech for the cover system", with quasi-coherent `F` only as the SEED
  at the 02KG instantiation. Do NOT specialize to QCoh.**
- **L3 `lem:absolute_cohomology_one_vanishing`** — update the statement prose to the effort-breaker's
  cover-local, hypothesis-driven signature:
  `(U : Opens X) {S : ShortComplex X.Modules} (hS : S.ShortExact) [Injective S.X₂]
   (hsurj : Function.Surjective (section map of S.g at U)) ⊢ H¹(U, S.X₁) = 0`,
  i.e. the only geometric input is the section surjectivity `I(U) ↠ Q(U)` taken as a hypothesis. Keep the
  existing detailed proof (Ext LES at `jShriekOU U` + injective vanishing on the 2nd arg + the H⁰≅Γ
  naturality `lem:absolute_cohomology_zero_natural` transferring `hsurj` to surjectivity of
  `g = H⁰(U, S.g)`, forcing `δ = 0`). The `\uses` is already correct (it lists
  `lem:absolute_cohomology_zero_natural` etc.).
- **L4 `lem:absolute_cohomology_pos_vanishing`** — update the statement prose to the `BasisCovSystem`
  signature: `(s : BasisCovSystem X) {F : X.Modules} (hF : HasVanishingHigherCech s F) {U} (hU : U ∈ s.B)
  {p} (hp : 0 < p) ⊢ H^p(U, F) = 0`. Proof shape (already mostly correct): induction on `p ≥ 1`
  generalizing over all `F` with `HasVanishingHigherCech s F`; closure-under-quotient is L2 (giving
  `HasVanishingHigherCech s Q`), re-supplying L3's `hsurj` for `Q` at each `U ∈ s.B` via TASK-6 per-face
  SES + `s.cofinal` + `ses_cech_h1`; base case is L3. Add `\uses{def:basis_cov_system,
  def:has_vanishing_higher_cech, lem:face_ses_of_sheaf_ses}` to the existing list.
- **top `lem:cech_to_cohomology_on_basis`** — keep as the thin assembly = L4 instantiated; ensure its
  prose references the `BasisCovSystem`-built instance. Its `\uses` is already correct.

## TASK 8 (coverage) — Bundle the 4 `AbsoluteCohomology.lean` private helpers
Into the `\lean{}` list of `lem:absolute_cohomology_zero_natural` (line ~3056), append the four private
naturality helpers so they leave `unmatched`:
`\lean{AlgebraicGeometry.absoluteCohomologyZeroAddEquiv_naturality,
AlgebraicGeometry.homEquiv₀_comp_mk₀, AlgebraicGeometry.freeYonedaHomEquiv_naturality,
AlgebraicGeometry.sheafificationHomAddEquiv_naturality, AlgebraicGeometry.jShriekOU_homEquiv_naturality}`.

---

## Acceptance / self-check
- `archon dag-query unmatched` drops to 0 (all 14 helpers covered; the new scaffold pins L3/L4/top +
  BasisCovSystem/HasVanishingHigherCech/face-SES are TODO-noted, not yet in Lean — that is expected and
  does NOT count as unmatched since unmatched = Lean-without-tex, not tex-without-Lean).
- No broken `\uses{}` (every label referenced exists). Run `archon dag-query` to confirm acyclic.
- All verbatim `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks preserved.
- No `\leanok` added/removed anywhere.
- LaTeX `\begin/\end` balanced.

## Out of scope
- Do NOT edit any other chapter. Do NOT edit `.lean` files. Do NOT add `\leanok`. Do NOT alter the
  protected `cech_computes_higherDirectImage` target or the P5a/P5b blocks.

## Write domain
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
- `references/**` (only if you need to re-open `references/stacks-cohomology.tex` to copy an existing
  verbatim quote — do not fetch new sources; the quotes you need are already in the chapter).
