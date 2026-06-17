# blueprint-writer directive — `Picard_TensorObjSubstrate.tex` (slug bw-tos261)

You may edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (+ `references/**` if you
need to re-open a source to copy a verbatim quote). Do NOT add/remove `\leanok` or `\mathlibok`
markers (managed deterministically elsewhere). This chapter is the consolidated blueprint for the
TensorObjSubstrate substrate (it covers `DualInverse.lean` too). It currently fails the prover-dispatch
HARD GATE (`correct: false`) on two stale items. Fix exactly these three things; change nothing else.

## Context (what is now TRUE, so the prose can be corrected)
- The iter-260 prover proved (in `DualInverse.lean`) that the route-(1) approach to `sliceDualTransport`
  — consuming the shared root `overEquivalence`'s `restrictOverIso`/`unitOverIso` — is **structurally
  insufficient**: those are isos of *sheaf objects* (`restrict ↦ over`, `unit ↦ unit`) and carry **no
  internal-hom / dual content**. The goal's content is that the **dual commutes with slice reindexing**
  along `f.opensFunctor`, which route-(1) cannot supply (it would need a monoidal-closed structure the
  project deliberately avoids).
- `pushforwardComp_lax_μ` and `pullbackComp_δ` (the Sq2b mate calculus) are both **CLOSED axiom-clean**.
  `pushforwardComp_lax_μ` was NOT the predicted "~150-LOC `extendScalarsComp`/`restrictScalarsComp`
  change-of-rings build"; the committed proof is a short **sectionwise pure-tensor collapse**: the
  pushforward tensorator μ reduces *definitionally* to the lighter `restrictScalars` μ on the
  strongly-monoidal `pushforward₀` objects (`pushforward_μ_eq`, `rfl`), after which
  `ModuleCat.restrictScalars_μ_tmul` kills every pure tensor `m ⊗ₜ n`. No `extendScalarsComp` anywhere.

## FIX 1 — rewrite the `sliceDualTransport` / leg-(A) paragraph to route-(2)
The proof block of `lem:dual_restrict_iso` already describes the GENUINE route-(2) structure correctly
in its earlier prose (the "Stage H1 — adjunction-uniqueness rewrite", "Leg (A) — slice-site Hom
base-change (Beck–Chevalley)", and "Leg (B) — ground-ring reconciliation" paragraphs, ~L5731–5771).
The problem is the LATER paragraph headed *"The leg-(A) atom `sliceDualTransport`"* (~L5786–5830),
which still describes `sliceDualTransport` as a *consumer / per-`V` localization of `overEquivalence`*
(route-1). Rewrite that paragraph so it is consistent with the route-(2) prose above it:

- `sliceDualTransport f M V` is the single `𝒪_Y(V)`-linear equivalence realizing **leg (A)** directly,
  **built by hand**, NOT obtained from `overEquivalence`/`restrictOverIso`/`unitOverIso`.
- Its forward/inverse map is the `eqToHom`-conjugation of the slice-Hom components across
  `f.opensFunctor`, transported along the down-set identity `image_preimage_of_le`
  (`ι(ι⁻¹(V)) = V` for an open immersion), with naturality discharged by `Subsingleton.elim` on the
  thin poset `Opens Y` — the SAME pattern already proved axiom-clean for `homLocalSection` and
  `dualUnitIsoGen`.
- The Step-4 residual is then `PresheafOfModules.isoMk` of the composite (leg (A) = `sliceDualTransport`)
  ; (leg (B) = `restrictScalarsRingIsoDualEquiv` along the ring iso `(f.appIso V).inv`), with the outer
  naturality thin-poset-trivial.
- Delete the iter-260 review `% NOTE ...` comment block (the one flagging route-1 as wrong) once you
  have applied the rewrite — it has served its purpose.

## FIX 2 — remove stale `\uses` edges on `lem:dual_restrict_iso`
In BOTH the statement block (`\uses{...}` near L5673) and the proof block (`\uses{...}` near L5702),
remove these three edges (route-(2) does not consume them):
`def:sheafofmodules_over_equivalence`, `lem:sheafofmodules_restrict_over_iso`,
`lem:sheafofmodules_unit_over_iso`. KEEP `lem:internal_hom_isSheaf` and
`lem:restrictscalars_ringiso_dualequiv`.

## FIX 3 — correct the Sq2b prose of `lem:pullback_tensor_map_basechange` (the D3′-outer lemma)
- The proof-method paragraph (~L4035–4058) that describes `pushforwardComp_lax_μ` as a
  `ModuleCat.extendScalarsComp` / `restrictScalarsComp` / `homEquiv_extendScalarsComp` build is
  **overstated** — rewrite it to the short sectionwise pure-tensor collapse described in "Context"
  above (`pushforward_μ_eq` reduces the pushforward μ definitionally to the `restrictScalars` μ; then
  `ModuleCat.restrictScalars_μ_tmul` collapses each pure tensor). State plainly that Sq2b
  (`pullbackComp_δ` together with `pushforwardComp_lax_μ`) is now fully discharged.
- The "genuinely missing ingredients" sentence (~L4091) still lists "Sq2b" as missing — this is
  **stale**. Remove Sq2b from that list; the only genuinely-remaining ingredients for
  `pullbackTensorMap_restrict` are **Sq1 (`sheafificationCompPullback` composition-coherence)** and
  **Sq4 (`pullbackValIso` composition-coherence)**.
- Delete the iter-260 review `% NOTE ...` comment blocks in this region once applied.

## Out of scope
Do not touch any other lemma, any other chapter, the group-law / `picCommGroup` material, or the
`exists_tensorObj_inverse` block. Keep all existing `% SOURCE` / `% SOURCE QUOTE` citation comments
intact (the Stacks 01CM internal-hom-pullback quote on `lem:dual_restrict_iso` stays).
