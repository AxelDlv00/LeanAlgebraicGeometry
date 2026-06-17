# Mathlib Analogist: d3cocycle006
**Mode:** cross-domain | **Iter:** 006

## Analogues Found
- **`CategoryTheory.conjugateEquiv_comp`** (`Mathlib/CategoryTheory/Adjunction/Mates.lean`):
  `conj adj₁ adj₂ α ≫ conj adj₂ adj₃ β = conj adj₁ adj₃ (β ≫ α)` — the factor-fuse as a NatTrans
  equation, NO dependent indices. Port: fuse recovered R1/R5 (as `B_f`/`B_h` conjugates) into the
  single `(h≫f)`-conjugate = `B_{h≫f}.unit`, replacing the failed `reassoc_of% key` splice (L2786).
  **Cost: low.**
- **`CategoryTheory.iterated_mateEquiv_conjugateEquiv`** (Mates.lean): mate across two STACKED
  adjunctions = conjugate of the COMPOSITE adjunction — the composite-adjunction coherence itself, as
  a whole-transformation equality. Port: principled frame for `sheafificationCompPullback_comp_tail`.
  **Cost: medium.**
- **`Adjunction.isMonoidal_comp` + `Functor.OplaxMonoidal.comp_δ`** (`Monoidal/Functor.lean`): δ of a
  composite of left adjoints = composite δ, a transformation identity. Port: D3′ `pullbackTensorMap_restrict`
  — combine with already-CLOSED `pullbackComp_δ` (L2282), conjugate the whole 4-fold composite once
  (cf. `mateEquiv_square`, the 4-square paste as ONE equation) before `.app`. **Cost: medium.**

## Top Suggestion
The dependent `eqToHom`/`Over.map`/`opensFunctor` reindex terms blocking every `rw` exist ONLY at the
`.app P` component level. Mathlib's `Mates.lean` proves all composite-adjunction coherences at the
**natural-transformation** level (objects = functors, composition = plain whisker/`≫`, zero reindex)
and evaluates `.app` exactly ONCE at the end — it never splices a component δ-square into a dependent
composite. The project's OWN `pullbackObjUnitToUnit_comp` (L920–993) is the working, axiom-clean
bare-adjunction instance of this technique (assembles via `homEquiv_naturality_left/right` +
`unit_conjugateEquiv` + `pushforwardComp.hom.naturality`, no splice). Port it to
`sheafificationCompPullback_comp_tail` (L2467): keep the caller's whole-equation transpose
(`homEquiv.injective`, L2721-2724) and DON'T split back to components; recover R1/R5 as `B_f`/`B_h`
conjugates via `sheafificationCompPullback_eq_leftAdjointUniq` (L1534) +
`homEquiv_leftAdjointUniq_hom_app`; fuse with **`conjugateEquiv_comp`** (the only new Mathlib lemma
needed) into `B_{h≫f}.unit`. The dangling `hwr` device (L2598, a `conjugateEquiv_whiskerRight` /
`conjugateEquiv_mateEquiv_vcomp` instance) is correct but is being consumed at the wrong
(post-splice, component) level — consume it at the transformation level instead. Then reuse the
identical discipline for D3′ via `isMonoidal_comp`/`comp_δ`/`pullbackComp_δ`.
First Mathlib read: `conjugateEquiv_comp` + `iterated_mateEquiv_conjugateEquiv` in
`Mathlib/CategoryTheory/Adjunction/Mates.lean`. First project file: `TensorObjSubstrate.lean` L2467.

## Structural problem
Prove a composite-of-left-adjoints unit cocycle (and the oplax δ coherence) for `sheafification ∘
pullback` over schemes, where each leg is itself a composite adjunction `(pullbackPushforward φ').comp
sheafAdj`; the naive proof splices a local δ-square / recovered factor into a long DEPENDENT component
composite by `congrArg`/`conv`/`reassoc_of%` and the dependent indices (`eqToHom`, `Over.map` reindex)
make the rewrite motive ill-typed.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `CategoryTheory.conjugateEquiv_comp` | mate calculus | low | ANALOGUE_FOUND |
| `CategoryTheory.iterated_mateEquiv_conjugateEquiv` | mate calculus | medium | ANALOGUE_FOUND |
| `Adjunction.isMonoidal_comp` + `OplaxMonoidal.comp_δ` | monoidal cat | medium | ANALOGUE_FOUND |
| `mateEquiv_vcomp` / `mateEquiv_hcomp` / `mateEquiv_square` | mate calculus | (support) | PARTIAL_ANALOGUE |
| `unit_conjugateEquiv` | mate calculus | (already used L2422) | ANALOGUE_FOUND |

## Discarded
- `Adjunction.leftAdjointCompNatTrans_assoc` (`CompositionIso.lean:155`) wholesale reduction — directive
  "Failed approaches" bullet 3: reduction opens but the final step is the same δ-splice. The Mates.lean
  cocycle lemmas are the correct-grain replacement (fuse at the conjugate level, never split to a component).
- `mateEquiv_apply`/`mateEquiv_symm_apply` direct use — too low-level (whiskered associator normal form);
  only Mathlib's internal `ext`+`simp` proofs need them, not the port.

## Persistent file
- `analogies/d3cocycle006.md` — full analogue list + port recipe captured for future iters.

Overall verdict: the splice is an artifact of working post-`.app`; lift the entire assembly to the
NatTrans/conjugate level and fuse legs with `conjugateEquiv_comp` (Mates.lean) — the model
`pullbackObjUnitToUnit_comp` already proves this works at the bare-adjunction level.
