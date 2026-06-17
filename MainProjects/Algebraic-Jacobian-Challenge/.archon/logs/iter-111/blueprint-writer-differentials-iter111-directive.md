# Blueprint Writer Directive

## Slug
differentials-iter111

## Target chapter
blueprint/src/chapters/Differentials.tex

## Strategy context

This project is opening Phase B with a prover lane on
`AlgebraicJacobian/Differentials.lean:113`
(`relativeDifferentialsPresheaf_isSheaf`). The chapter's
`\thm:relative_kaehler_isSheaf` proof block was expanded in iter-110
with named Mathlib lemmas + Stacks/Hartshorne refs, but the
blueprint-reviewer-iter111 audit fired the HARD GATE because the
proof block has **3 must-fix items** that prevent the prover from
formalizing without inventing helpers:

1. **Basis-to-opens descent direction is wrong**: Step~1 (lines ~30-32)
   names `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` for extending
   the affine-basis sheaf condition to all opens, BUT that Mathlib
   lemma's signature is `IsSheaf → IsSheafUniqueGluing` — i.e. it
   converts a finished `IsSheaf` proof into a unique-gluing predicate,
   not the converse the recipe needs.

2. **Wrong Mathlib name for localisation tensor iso**: Step~2 (lines
   ~34-37) names `KaehlerDifferential.tensorKaehlerEquiv` for the iso
   `Ω_{B[1/f]/A} ≅ Ω_{B/A} ⊗_B B[1/f]`. Both
   `KaehlerDifferential.tensorKaehlerEquiv` and
   `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` exist in
   Mathlib but with **different shapes**:
   - `tensorKaehlerEquiv` (in `Mathlib.RingTheory.Kaehler.TensorProduct`)
     requires `Algebra.IsPushout R S A B` and produces
     `TensorProduct A B Ω[A⁄R] ≃ₗ[B] Ω[B⁄S]`.
   - `tensorKaehlerEquivOfFormallyEtale` (in `Mathlib.RingTheory.Etale.Kaehler`)
     requires `Algebra.FormallyEtale S T` and produces
     `TensorProduct S T Ω[S⁄R] ≃ₗ[T] Ω[T⁄R]` — this is the right shape
     for our localisation argument (R = A base, S = B, T = B[1/f],
     since `Algebra.FormallyEtale B (Localization.Away f)` holds).
   - **The cleanest entry point is actually `KaehlerDifferential.isLocalizedModule_map`**
     (in `Mathlib.RingTheory.Etale.Kaehler`) which directly gives the
     `IsLocalizedModule` instance and is what the existing Lean stub
     in `Differentials.lean:113` already mentions at L72-105 as the
     intended hook. Using `IsLocalizedModule` directly avoids
     instantiating the tensor-product iso shape entirely.

3. **Unnamed "tensoring preserves exactness" / "refinement's universality"
   hand-waves**: Step~2 final paragraph and Step~3 last sentence
   ("tensoring a B-module with the standard sheaf condition for O_V
   over the cover {D(f_i)} preserves exactness when the cover is
   finite"; "the unique-gluing axiom on the original cover follows
   from the refinement's universality") describe recipes without
   pinning Mathlib lemma names. The prover has to invent the descent
   step from scratch.

## Required edits

You must fix the `\thm:relative_kaehler_isSheaf` proof block at lines
~28-47 of `Differentials.tex`. The shape of the fix is:

### Step 1 (basis-to-opens descent) — REWRITE

Replace the current "Reduction to the affine basis of abelian-group
sections" framing. The corrected mathematical recipe is:

A presheaf of `O_X`-modules `F.presheaf` is a sheaf in the Grothendieck
topology iff its underlying presheaf of types is a sheaf, by
`TopCat.Presheaf.isSheaf_iff_isSheaf_comp` against the forgetful
functor to types (which reflects isomorphisms and preserves limits).
This forgetfulness reduces the goal to a presheaf-of-types sheaf
condition.

For the descent from the affine basis (`AlgebraicGeometry.Scheme.isBasis_affineOpens`)
to all opens, the cleanest Mathlib hook is to verify the equivalent
condition `TopCat.Presheaf.IsSheafPairwiseIntersections` (via
`TopCat.Presheaf.isSheaf_iff_isSheafPairwiseIntersections`), or
equivalently `IsSheafEqualizerProducts`
(via `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts`),
on covers refined to lie in the affine basis. The prover must spell
this out OR consult Mathlib for whether a "sheaf-on-basis ⇒ sheaf"
lemma exists directly (e.g.\ around `TopCat.Sheaf.OnBasis`,
`Presheaf.SheafOnBasis`, or `AlgebraicGeometry.SheafOnAffineOpens`).
**Do not name `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` as the
descent hook — its direction is wrong.**

If a direct Mathlib "sheaf-on-affine-basis ⇒ sheaf" lemma is **not**
located, write the descent step explicitly: given an arbitrary open
cover, refine to an affine-basis cover (using `isBasis_affineOpens`),
verify the equalizer-products condition on the refined cover (using
`isSheaf_iff_isSheafEqualizerProducts`), and lift back to the original
cover via uniqueness on the refinement. Spell this out with one
sentence per step naming the Mathlib lemma at each step.

You may verify Mathlib's offerings via `lean_leansearch`,
`lean_loogle`, and `lean_hover_info` (read-only Lean LSP) to discover
the right lemma names; do NOT invent names. If you genuinely
cannot find a Mathlib lemma for the basis-to-opens step, flag it
as "needs Mathlib gap-fill" in your report — DO NOT paper over it
with vague prose.

### Step 2 (affine basis via localisation) — TIGHTEN

The affine basis case proceeds as follows (replace lines ~34-42):

Fix an affine open `V = Spec B` of `X` over `U = Spec A` of `S`,
and a basic open `D(f) ⊆ V` for `f ∈ B`. The presheaf assigns to
`D(f)` the `B[1/f]`-module `Ω_{B[1/f]/A}` (via the affine-restriction
identification). Mathlib's
`KaehlerDifferential.isLocalizedModule_map` (in
`Mathlib.RingTheory.Etale.Kaehler`) provides, as an `IsLocalizedModule`
instance over the multiplicative set `Submonoid.powers f`, that the
canonical map `Ω_{B/A} → Ω_{B[1/f]/A}` exhibits the latter as the
localisation of the former at `Submonoid.powers f`.

[Optionally — only if useful — note that this is equivalent to the
`B[1/f]`-linear isomorphism `Ω_{B/A} ⊗_B B[1/f] ≃ Ω_{B[1/f]/A}`
obtained via `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`
applied with `R = A`, `S = B`, `T = B[1/f]` (using that
`Algebra.FormallyEtale B (Localization.Away f)` holds for any `f`).
Do NOT use the bare name `KaehlerDifferential.tensorKaehlerEquiv` —
its `Algebra.IsPushout` shape is not the directly applicable form
in this setting.]

For the sheaf condition on a basic-open cover
`V = ⋃ D(f_i)` (equivalent to `(f_1, …, f_n) = (1)` in `B`),
the equalizer-products diagram

  `Ω_{B/A} ⟶ ∏ Ω_{B/A} ⊗_B B[1/f_i] ⟶ ∏ Ω_{B/A} ⊗_B B[1/f_i f_j]`

is exact because localisation of a `B`-module at a basic-open cover
satisfies the equalizer-products condition: this is the affine sheaf
condition for the quasi-coherent sheaf `M~` on `Spec B` associated
to the `B`-module `M = Ω_{B/A}`. Pin this to a concrete Mathlib
lemma name: candidates to verify in Mathlib are
`Algebra.IsLocalization.isSheaf`,
`AlgebraicGeometry.StructureSheaf.isSheaf_module`,
`AlgebraicGeometry.SheafOfModules.IsQuasicoherent`-related lemmas
in the affine-scheme module-sheaf API, or a finite-cover-localization
lemma. **Find the correct name and put it in the chapter; do not
paraphrase.**

### Step 3 (basis-to-opens) — REMOVE the hand-wave

Replace "the unique-gluing axiom on the original cover follows from
the refinement's universality" with whatever specific Mathlib lemma
the rewritten Step~1 uses. If Step~1 already names the descent hook
correctly, Step~3 collapses into "by the basis-to-opens descent of
Step~1, applied to the affine-basis sheaf condition of Step~2."

### Other notes

- **You MAY dispatch a `lean-leansearch` / `lean-loogle` MCP probe**
  to find the correct Mathlib names — this is fast (1-3 calls).
- **Each Mathlib name in the rewritten proof block MUST carry a
  confidence tag**: `[verified]` (you ran a search and confirmed),
  `[expected]` (named but not verified — for whatever reason the
  search couldn't surface it), or `[gap]` (you searched and the
  name is not present). The plan agent gates the prover dispatch
  on `[verified]` quality.
- **L877 `\thm:serre_duality_genus` (L214-224)** is intentionally
  short (named Mathlib gap #7, mathlib-analogist-serre-duality-iter110).
  DO NOT touch.
- **L636 `cotangentExactSeq_structure.h_exact`** is named Mathlib
  gap #2 (deferred parallel to `instIsMonoidal_W`). DO NOT touch
  the `\lem:cotangent_exact_structure` prose at L98-117.
- The dormant-by-design lemmas at L126-145 (`\lem:sheafOfModules_exact_iff_stalkwise`,
  `\lem:sheafOfModules_epi_of_epi_presheaf`,
  `\lem:derivation_postcomp_comp`) are intentionally left as
  prose-only. DO NOT touch.
- **L718 `\thm:smooth_iff_locally_free_omega` (L176-193)** and
  **L735 `\cor:cotangent_at_section` (L195-208)** were already
  expanded iter-110 with adequate proof sketches. DO NOT re-expand
  unless you find a concrete error.
- **You SHOULD NOT touch any other chapter.** If you spot a cross-
  chapter inconsistency, flag it in your report's "Notes for Plan
  Agent" section; the plan agent decides what to do.

## Out of scope

- Cross-chapter edits.
- Lean file edits.
- The L877/L636/dormant-prose-only items called out above.
- Anything outside the `\thm:relative_kaehler_isSheaf` proof block
  (lines ~28-47).

## References

- `references/challenge.lean` — authoritative protected signatures
  for the project.
- Stacks Project, Tag 01UM (K\"ahler differentials commute with
  localisation), Tag 02HQ (Jacobian criterion), Tag 02HW (smooth
  morphism iff Ω locally free of correct rank).
- Hartshorne, *Algebraic Geometry*, II.8 (Propositions 8.2A, 8.7;
  Corollary 8.10).

## Expected outcome

`Differentials.tex` `\thm:relative_kaehler_isSheaf` proof block
(L28-47) becomes prover-ready: every Mathlib lemma name is correct
and tagged with confidence, the basis-to-opens descent is pinned
to a specific lemma (or honestly flagged as a Mathlib gap if no
direct route is available), and the "tensoring preserves exactness"
+ "refinement's universality" hand-waves are replaced with concrete
named lemmas. After your edits, the chapter should pass the
blueprint-reviewer HARD GATE for the iter-112 L122 prover dispatch.
