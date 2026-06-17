# Mathlib Analogist Report

## Mode
api-alignment

## Slug
need1-finish

## Iteration
060

## Question
Discharge the two `sorry` holes in `OpenImmersionPushforward.lean` (lines 484/485) under the
spectrum equivalence `Φ = Scheme.Modules.pushforwardEquivOfIso φ`, `φ : U ≅ Spec R`:
`hjt : Φ.functor.obj (jShriekOU V) ≅ jShriekOU (φ.inv ⁻¹ᵁ V)` and
`hqc : (Φ.functor.obj H).IsQuasicoherent` for quasi-coherent `H`. Produce the shortest compiling
route for each (or the precise minimal residual), and write up both recipes.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| `hjt` (jShriekOU transport iso) | **PROCEED — compiles, axiom-clean** | informational |
| `hqc` (pushforward-of-iso preserves qcoh) | **NEEDS_MATHLIB_GAP_FILL** | informational |

## Informational

### `hjt` — SOLVED this iteration (compiled, axiom-clean)
The directive's `q2` proof was compiled via `lean_run_code` (imports
`OpenImmersionPushforward` + `AbsoluteCohomology`). `#print axioms q2` =
`[propext, Classical.choice, Quot.sound]`. The proof is ~12 lines and rests entirely on existing
API: `Adjunction.compCoyonedaIso`, `Coyoneda.fullyFaithful.preimageIso`, `Functor.isoWhiskerLeft/Right`,
the project's `sectionsFunctorCorepIso`, and two `rfl`s
(`preadditiveCoyoneda.obj X ⋙ forget = coyoneda.obj X`;
`pushforward f ⋙ sectionsFunctor V = sectionsFunctor (f⁻¹ᵁ V)`).

**Framing correction (act on this):** prior prover/blueprint notes calling `hjt` a "deep
adjunction-mate / high-LOC / confirmed Mathlib gap" are WRONG. There is no mate transposition and no
naturality square to discharge by hand — it is a short corepresentability transport. The prover
should paste `q2` in directly. Verbatim proof + the load-bearing facts are in
`analogies/need1-transport.md`.

### `hqc` — minimal residual: "pushforward along a scheme iso preserves quasi-coherence"
Confirmed Mathlib gap: the whole AG layer instantiates `IsQuasicoherent` only for `tilde`
(`Tilde.lean` is the sole AG file naming it); `infer_instance` for
`(Φ.functor.obj H).IsQuasicoherent` from `[H.IsQuasicoherent]` fails; no
`pushforward`/`pullback` + `IsQuasicoherent` lemma exists.

Why no shortcut: `IsQuasicoherent M = Nonempty (QuasicoherentData M)` is a **local** datum (a cover
of the site `Opens U` + a `Presentation` of `M.over (Xᵢ)`). On the abstract affine `U`, `H` has only
*local* presentations, so `Presentation.map` (the global-presentation transport) does not apply;
and iso-closure (`instIsClosedUnderIsomorphismsIsQuasicoherent`, used in-project as
`(isQuasicoherent _).prop_of_iso`) is **same-site only**, so it cannot bridge
`U.Modules → (Spec R).Modules`. Transporting a *local* condition across `Φ` requires the functor to
commute with **restriction to opens** — exactly the over-site machinery in
`QuasicoherentData.bind` (`pushforwardPushforwardEquivalence` + `Over.iteratedSliceEquiv`).

**Precise residual lemma** (full skeleton + ranked sub-facts in `analogies/need1-transport.md`):
```lean
lemma isQuasicoherent_pushforwardEquivOfIso {X Y : Scheme.{u}} (φ : X ≅ Y)
    (H : X.Modules) [H.IsQuasicoherent] :
    ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).IsQuasicoherent
```
Route = `IsQuasicoherent.of_coversTop` over the image cover `fun i => φ.inv ⁻¹ᵁ (q.X i)`, each piece
qcoh by transporting `q.presentation i` across an over-site equivalence (`Presentation.map` then
`Presentation.ofIsIso`), structurally a copy of `QuasicoherentData.bind`'s `presentation` field.
The single non-trivial input is **R1**: the comparison iso
`eᵢ.functor.obj (H.over Vᵢ) ≅ (Φ_*H).over (φ.inv⁻¹Vᵢ)` ("pushforward commutes with restriction to an
open"), ~40–100 LOC. R2 (`η : eᵢ.functor.obj unit ≅ unit`) and R3 (image cover covers ⊤, via the
homeomorphism) are cheap. Not circular; not blocked on any further Mathlib gap beyond R1.

To sidestep the `of_coversTop` instance-search timeout flagged in the directive: provide each per-`i`
`IsQuasicoherent` as an explicit term-mode `haveI`, never via class search.

## Persistent file
- `analogies/need1-transport.md` — verbatim axiom-clean `hjt` proof + the `hqc` residual lemma,
  proof skeleton, ranked sub-facts (R1/R2/R3), and the confirmed API inventory.

Overall verdict: `hjt` is done and axiom-clean (drop it in, kill the "deep-mate" framing); `hqc` is a
genuine Mathlib gap whose shortest route is a `QuasicoherentData`/`of_coversTop` transport reducing to
one geometric comparison iso (R1 — "pushforward commutes with restriction to an open").
