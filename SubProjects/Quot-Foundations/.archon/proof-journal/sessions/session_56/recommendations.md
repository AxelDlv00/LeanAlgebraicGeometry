# Iter-056 → Iter-057 Recommendations

## TOP — must-fix-this-iter (from lean-auditor)
1. **GrassmannianQuot.lean L162–173 — stale scaffold NOTE on `glue` (prover/refactor, `.lean`).** The NOTE
   says the `glue` body is "still to be filled" / "cocycle conditions remain to be added"; the body IS the
   closed equalizer-of-pushforwards at L245–307. It actively misleads the next prover touching the 3
   `glue`-dependent sorries. Have the GRQUOT prover (or a refactor pass) replace it with an accurate note that
   `glue` is closed and the remaining work is the GL_d bundle cocycle. (Out of review's write domain.)

## HIGH / closest-to-completion
2. **GF `genericFlatness` is one prove-mode lane from CLOSING — the only project headline with a single
   isolated sorry whose every ingredient is confirmed present.** The base-change blocker is GONE (built
   axiom-clean this iter). Dispatch a **prove-mode** (NOT mathlib-build, NOT escalation) lane on `flatV`
   (L3285): thread `Module.free_of_isLocalizedModule` (transports retained `hfree` to `(M_i)_f` free over
   `A_f`) + B1 `gf_flat_localizedModule_sameBase` (keeps `A_f`-flatness under source-localization at `powers ḡ`)
   + `isLocalizedModule_basicOpen`, transport `Γ(F,Dg)=Γ(F,Dḡ)` via `hbo`. The two hard threads: (i)
   action-compatibility between `modV` and the freeness-route `A_f`-action; (ii) iterated-localization
   identifications (`Localization.Away f` over `Localization.Away (f0 i)`; `(M_i)_ḡ` over `(M_i)_f`).
   Estimated ~150–250 LOC. The progress-critic "STUCK on missing base change" condition is now FALSE.

3. **GR-quot: `glue` keystone CLOSED — pivot the lane to the GL_d bundle transition cocycle.** The 3 remaining
   sorries (`universalQuotient` L393, `tautologicalQuotient` L404, `represents` L898) are NOT reachable from
   `glue`; they need net-new infra: `g I J` = matrix automorphism of `free (Fin d)` from `universalMinorInv`
   (build like `chartQuotientMap`), `hC1` self-identity, `hC2` triple-overlap multiplicativity (the **hard
   part** — relate the module cocycle to the matrix cocycle `universalMinorInv` identities already in
   `GrassmannianCells.lean`). **Blueprint-expand the descent sub-pieces (effort-break the cocycle) BEFORE any
   prover dispatch** — this is a ~200–400 LOC construction comparable to `glue` itself.

## MEDIUM
4. **Blueprint prose rewrite for the `glue` route (blueprint-writer).** GrassmannianQuot chapter still describes
   the abandoned hand-built `gluePresheaf`/`gluePresheafModule`/`gluePresheafIsSheaf` route (3 phantom blocks,
   `\lean{}` pins at non-existent decls; `% NOTE:` added this phase). Dispatch a blueprint-writer to rewrite the
   Construction paragraph of `def:scheme_modules_glue` to the equalizer-of-pushforwards route and drop the 3
   phantom `\uses` edges (L271–272). Until done, leandag treats `glue`'s `\uses` cone as referencing
   non-existent Lean.
5. **SNAP `relTensorActL` — try handle (1) before any more helper rounds.** The lane is blocked on the
   `↥(P.obj U)` vs `↥((P.presheaf).obj U)` carrier gap (NOT a missing lemma; the reduction succeeds in isolation
   when carriers agree). Handle (1): build a DISTINCT `↥(P.obj ·)`-carrier ℤ-linear restriction (from `P.map f`
   / `ModuleCat.Hom.hom` + a `restrictScalars` carrier-identity) and use it UNIFORMLY in
   `relTensorTriplePresheaf`/`relTensorDomainPresheaf` AND `actLmap`, then re-prove the (now trivial)
   `map_id`/`map_comp`. Do NOT re-try changing the `obj` carriers (CASCADES — ruled out this iter). If handle
   (1)+(2) both fail, escalate for a Mathlib-side abelian-restriction-on-tmul `@[simp]` apply lemma. Presheaf
   promotion is genuinely multi-iter — give a multi-iter budget or split into sub-objectives.
6. **SNAP superseded handoff block (prover/refactor, `.lean`).** SectionGradedRing.lean L559–641 is a full
   `(superseded)` analysis whose body says "NOT a carrier mismatch", contradicting the authoritative primary
   block (L504–558, "carrier gap"). Prune to just the `inferInstanceAs` detail it claims to retain.

## Coverage debt (leandag unmatched=5 — planner to blueprint)
- `AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf` (SectionGradedRing.lean L476): NEW domain-row
  triple-tensor presheaf, sibling of `def:relTensorDomainPresheaf`. Add `def:relTensorTriplePresheaf` under
  `\cref{lem:relativeTensor_as_coequalizer}`, `\uses{lem:presheafModule_monoidal_mathlib}`. Proof depends on
  functoriality of `TensorProduct.map`.
- `AlgebraicGeometry.gf_stalk_flat_localBase` (FlatteningStratification.lean L2746): stalk-free algebraic core,
  referenced in-code as `lem:gf_stalk_flat_localBase` but has NO blueprint block. Add the block (or correct an
  existing pin) so it leaves the unmatched list.
- `AlgebraicGeometry.gf_flat_of_isEpi` / `gf_isEpi_restrict_of_affine_le`: NOW MATCHED (review corrected the two
  `\lean{}` pins in `lem:gf_flat_descend_isEpi` / `lem:gf_openImmersion_isEpi`); they will drop off unmatched on
  the next dag rebuild and `sync_leanok` will mark them `\leanok`.
- `AlgebraicGeometry.Scheme.Modules.opensTopology`: intentional private impl detail (leave unmatched).

## Minor (lean-auditor, `.lean` cleanups)
- FlatteningStratification.lean L3153: STATUS header `(iter-055)` should read `(iter-056)` (two of its bullets
  are iter-056 items).
- FlatteningStratification.lean L3132–3133: 30-iter-stale `SIGNATURE CORRECTNESS FIX (iter-023)` ratification
  notice — delete the dead clause.

## Do NOT re-assign as-is
- SNAP `relTensorActL` via changing `obj` carriers (CASCADES — breaks proven `relTensorDomainPresheaf.map_id`/
  `map_comp`). Use handle (1) instead.
- FBC remains parked (off critical path; un-parks only if GF+QUOT+GR close with `_legs_conj` open).
