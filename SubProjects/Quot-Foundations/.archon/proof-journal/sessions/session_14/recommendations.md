# Recommendations for iter-015 (from session_14 review)

## Verdict: clean iter — both CHURNING-must-close walls broke. 0 must-fix across 3 review subagents.

Both targets SOLVED axiom-clean (FBC Seam 1 `base_change_mate_unit_value`; GF `gf_torsion_reindex`).
The progress-critic's two CHURNING correctives both worked. No deferral, no escalation triggered.

---

## HIGH — blueprint-writer round REQUIRED before re-dispatching the GF lane

**`lem:gf_torsion_reindex` "Transitivity" step is under-specified** (lvb-gf MAJOR). The chapter's
4-line sketch produced a ~200-line Lean proof; the 5 new unmatched helpers are the evidence of the
gap. Before any prover touches the downstream GF lane (L5), dispatch a **blueprint-writer** on
`Picard_FlatteningStratification.tex` to:

1. **Expand the "Transitivity" step of `lem:gf_torsion_reindex`** — add a "Localisation transport"
   sub-step describing the two-localisation strategy (`MC`-localisation `Tg' = LocalizedModule MC T`
   vs the goal's `powers g`-localisation `T_g`), the `ebar` ring-automorphism construction
   (`IsLocalization.ringEquivOfRingEquiv`, NOT `algEquivOfAlgEquiv`), and the `pullbackModuleAddEquiv`
   /`extendScalarsOfIsLocalization` transport. Note the canonical-`OreLocalization`-action-diamond
   wall (the existential binder is overridden by the global instance).
2. **Add `\lean{...}`+`\label`+`\uses` blocks for the 5 new helper decls** (namespace
   `AlgebraicGeometry.GenericFreeness`, all in `FlatteningStratification.lean`, all axiom-clean,
   all consumed by `gf_torsion_reindex`) — these are the 5 unmatched `lean_aux` nodes (see Coverage
   debt below). May fold the three additive-transport helpers under one block.
3. **Update the stale L5 blueprint prose** if it still says the reindex is "blocked/still sorry".

This is a 1-iter latency cost that prevents the next GF prover from churning on a thin guide.

## HIGH — next live frontiers (dispatchable once gated)

1. **FBC Seam 2 — `base_change_mate_fstar_reindex`** (line ~1170). The new FBC critical path, now
   unblocked by Seam 1. It is the **generic-pullback-square pseudofunctor reindex** (NOT an
   adjunction-unit identity — a fundamentally different construction). Approach: mirror
   `base_change_mate_codomain_read`'s leg-identification scaffold (it already uses
   `pullback_fst_snd_specMap_tensor` + `pullbackSpecIso` + `unit_iso`); identify legs
   `pullback.fst/snd` with `Spec inclA`/`Spec inclR'`, transport the 3 pushforward coherences
   (`pushforwardComp ×2`, `pushforwardCongr`), feed Seam 1. Expect the same `erw` / `← Functor.comp_map`
   discipline. Closing Seam 2 opens Seam 3, which cascades to `section_identity` / `generator_trace` /
   `cancelBaseChange`. FBC chapter coverage is 34/34 and the Seam-1 sketch is adequate (lvb-fbc 0
   major) — gate is clear for an FBC lane.
2. **GF L5 — `exists_free_localizationAway_polynomial`** (line ~1267), now unblocked by the reindex.
   5-step assembly (documented inline): equip `T = N⧸range φ` with `Module.Finite P_d T`; apply
   `gf_torsion_reindex`; base-generalised IH at `A_g`; descend `A_g→A` via
   `free_localizationAway_of_free_of_eq_mul` (L3b); splice the localised SES via
   `exists_free_localizationAway_of_shortExact` (L3). Steps 1 and 5 carry their own
   restriction-of-scalars / SES-localisation plumbing. **Gate on the blueprint-writer round above.**
3. **QUOT mathlib-build (graded-API G1–G5)** — the unconditional iter-015 commitment from the
   iter-014 plan (progress-critic accepted the iter-014 set-up only with this commitment). The
   graded-API blueprint was written + cleaned iter-014; iter-015's mandatory whole-blueprint review
   gates it.

## MEDIUM — coverage debt: 5 unmatched `lean_aux` nodes (planner must blueprint)

`archon dag-query unmatched` reports exactly 5, all axiom-clean, all in
`AlgebraicGeometry.GenericFreeness` (`FlatteningStratification.lean`), all consumed by `gf_torsion_reindex`:

- `pullbackModuleAddEquiv` — `@[reducible] def`; pull back an `R`-module structure along an `≃+`
  (`r • y := e (r • e.symm y)`). No deps.
- `finite_of_pullbackModuleAddEquiv` — `Module.Finite` transports across the above. Uses `Module.Finite.equiv`.
- `pullback_isScalarTower` — `IsScalarTower` transports across the pulled-back structures. Uses `smul_assoc`.
- `finite_of_quotientRingEquiv` — transport `Module.Finite` across a ring iso of the acting ring
  compatible with `R`-algebra structures. Uses `AlgEquiv.ofRingEquiv`, `Module.Finite.equiv`, `Module.Finite.trans`.
- `isLocalizedModule_restrictScalars` — descent of an `IsLocalizedModule` along a scalar tower
  (image-submonoid → base submonoid). Uses `isLocalizedModule_iff`/`IsLocalizedModule.mk`,
  `Module.End.isUnit_iff`, `IsScalarTower.algebraMap_smul`.

(Covered by item 2 of the HIGH blueprint-writer round above — listed here for the unmatched-node ledger.)

## MEDIUM — stale comment (prover-cleanup; review cannot edit `.lean`)

- `FlatteningStratification.lean:1322–1323` (lean-auditor + lvb-gf): comment inside
  `exists_free_localizationAway_polynomial` still says "once `gf_torsion_reindex` (L5b, still `sorry`)
  lands" — it landed this iter. The `sorry` at line ~1337 is still legitimate (assembly steps 1,3,4,5
  remain) but the stated blocking reason is now false and misleads. The next prover owning the file
  should refresh it to "assembly of steps 1–5".

## LOW

- FBC Seam-1 sketch could name its 3 intermediate coherence steps (Claim A via tilde right-triangle;
  β-naturality; `unit_conjugateEquiv_symm`) to be a reliable guide for Seams 2–3 (lvb-fbc minor).
  Optional; fold into the FBC writer round if one runs.
- 3 known-tracked lean-auditor major + 3 minor are the legacy cross-project STATUS comments
  (iter-234/236/240/241 in FlatBaseChange.lean; iter-177+ in QuotScheme.lean) — prover-cleanup, no
  new action.
- 22 `CategoryTheory.Sheaf.val` deprecation warnings in FlatBaseChange.lean — cosmetic.

## Do NOT retry / settled

- **Do not re-dispatch a GF L5 prover before the blueprint "Transitivity" expansion lands** — it would
  churn on the same thin guide that needed 200 lines + 5 helpers to fill.
- The two closed targets are done axiom-clean; do not reopen. The `algEquivOfAlgEquiv` route for the
  reindex base-change is a confirmed dead end on doubly-indexed rings — `ringEquivOfRingEquiv` is the
  settled idiom.
