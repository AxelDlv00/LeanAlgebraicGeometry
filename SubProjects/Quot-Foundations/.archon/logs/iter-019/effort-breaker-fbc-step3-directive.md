# Effort Breaker Directive

## Slug
fbc-step3

## Target
lem:base_change_mate_fstar_reindex_legs   (in `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`, statement at line ~1615, proof following)

## Granularity
fine — one mathematical claim per lemma. A prior coarser blueprint expansion of this proof (iter-018) was reviewer-gate-passed but a post-prover per-file check found it STILL inadequate: the prover could not close the residual sorry from the prose. This goal's step-(iii) "mate-unwinding crux" has been unmoved for 5 consecutive prover iterations. Break it into a `\uses`-linked chain of small named sub-lemmas, each small enough that its proof is a few moves, so a fine-grained prover can formalize them one at a time.

## Proof structure
This is a project-bespoke categorical computation (no external source). The goal proves the
"fstar-reindex" leg equality of the i=0 base-change mate, instantiated at the literal pullback
projection legs (`hfst`, `hsnd` already `subst`'d in the Lean proof). The surviving obligation is a
~150-LOC telescoping over change-of-rings dictionaries. The concrete proof structure to cut along
(established by the iter-018 prover; the exact factor names are below — express them mathematically):

Notation in scope:
- `e` = the pullback–Spec comparison iso `pullbackSpecIso R A R'` (an isomorphism of schemes);
- `ιA` = the includeLeft ring map `A → R'⊗_R A`, `Spec ιA` its Spec;
- `g'` = the composite `e ≫ Spec ιA`;
- `η_h` = the unit of the (pullback ⊣ pushforward) adjunction along a morphism `h`;
- `pushforwardComp`, `pullbackComp` = the pseudofunctor coherence isos for a composite;
- the "codomain read" = `lem:base_change_mate_codomain_read_legs`, an already-stated lemma giving the
  inner composite as `iso_g ≫ unit_iso ≫ pushforwardComp(...).symm`;
- "Seam 1" = `lem:base_change_mate_unit_value` (already proved): the affine unit `η_{Spec ιA}` reads,
  through the tilde/Γ dictionaries, as the algebraic extend/restrict-scalars unit `η^alg_M`;
- `def:base_change_mate_inner_value` = the target inner value `ρ`, built from Seam 1 transported by
  `restrictScalars` along the ring equation `ιA∘φ = ιR'∘ψ`.

Cut into these atomic sub-lemmas (one mathematical claim each):

(S-iii-1) **Unit expansion / "invert the comp-coherence".** The pullback–pushforward unit of the
composite `g' = e ≫ Spec ιA` equals the telescoped composite
`η_{Spec ιA} ≫ (Spec ιA)_*(η_e) ≫ pushforwardComp(e, Spec ιA).hom ≫ g'_*(pullbackComp(e, Spec ιA).hom)`.
(Mathematically: the pseudofunctor unit-coherence for a composite, rearranged so the bare composite
unit `η_{g'}` is expressed via the two factor units plus the comp-coherence isos; this is the
inversion of the standard `pullbackPushforward_unit_comp` identity, valid because `pullbackComp` is an
iso.) `\uses{lem:pullbackPushforward_unit_comp}`.

(S-iii-2) **Distribute the unit through `(Spec φ)_* ⋙ Γ`.** Applying the global-sections-of-pushforward
functor to the expanded unit distributes over the composite (functoriality of `Γ∘pushforward`), so the
mate's unit factor becomes the corresponding composite of the four images.

(S-iii-3) **`e`-factor cancellation against the codomain read.** Because `e` is an isomorphism, the two
`e`-dependent factors from (S-iii-1) — `(Spec ιA)_*(η_e)` and `g'_*(pullbackComp(e, Spec ιA).hom)` —
cancel against the `unit_iso` and `pullbackComp(e, inclA).symm` pieces inside the codomain read
`lem:base_change_mate_codomain_read_legs`, leaving only the affine unit `η_{Spec ιA}` (read through the
codomain read's residual transport). `\uses{lem:base_change_mate_codomain_read_legs}` (and a Mathlib
anchor for "pullback along an iso is an equivalence", if you judge one is needed — name it only if you
are confident of the exact Mathlib declaration; otherwise leave it as a `\uses` to a stated step).

(S-iii-4) **Affine-unit value (Seam 1 application).** The surviving affine unit `η_{Spec ιA}`, read
through the tilde/Γ dictionaries, is the algebraic extend/restrict-scalars unit `η^alg_M`. This is a
direct application of the existing Seam 1. `\uses{lem:base_change_mate_unit_value}`.

(S-iii-5) **Match the inner value.** Reading `η^alg_M` over `Spec R` via `restrictScalars ψ` and the
ring equation `ιA∘φ = ιR'∘ψ` yields exactly `def:base_change_mate_inner_value` (= ρ), closing the
goal. `\uses{def:base_change_mate_inner_value, lem:base_change_mate_unit_value}`.

Then **rewrite the target's proof** to: "by (S-iii-1)…(S-iii-5)", with the target keeping its statement
and `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` unchanged, and its `\uses{}` updated
to include the new sub-lemma labels.

Assign each new sub-lemma a `\lean{}` hint by convention under namespace
`AlgebraicGeometry` (e.g. `base_change_mate_fstar_reindex_legs_unitExpand`,
`..._gammaDistribute`, `..._eCancel`, `..._affineUnit`, `..._innerMatch`) and list the assigned names
in your report's "Notes for dispatcher" so I can confirm them in PROGRESS.md for the fine-grained prover.

## Strategy context
FBC-A route (STRATEGY "FBC route"): prove the affine i=0 base-change lemma DIRECTLY on global sections
via the proved tilde dictionaries, reducing to Mathlib `cancelBaseChange`. The mate is computed through
a 3-seam decomposition; Seam 1 (`base_change_mate_unit_value`) is fully proved; this target is the
"Seam 2 / fstar-reindex" leg, the live bottleneck. Closing it cascades to Seam 3
(`base_change_mate_gstar_transpose`) → `affineBaseChange_pushforward_iso` →
`flatBaseChange_pushforward_isIso`.

## References
- None external — this is the project's own adjoint-mate calculus over the proved change-of-rings
  dictionaries. Do NOT fabricate a citation; these blocks are Archon-original (omit `% SOURCE` lines).
