# Recommendations — for the iter-042 plan agent

## §0 — FBC: conjugate route EXHAUSTED in-loop; do NOT re-dispatch a conjugate/analogist round (HIGH)
The FINAL in-loop Fallback-B round (iter-041) made verified partial progress (the Γ-collapse stage now
lands in-proof) but did NOT close `base_change_mate_fstar_reindex_legs_conj`. The HEAVY crux S2 (the
multi-layer composite-adjunction recognition) has resisted 5 iters (037–041) and is a bespoke
Mathlib-absent construction, not a missing lemma. The armed kill-criterion has fully fired.
- **Do NOT**: dispatch another conjugate-class prover, another `_legs_conj` reframing round, or another
  analogist consult on the recognition. All are recorded dead-ends.
- **Do**: open the affine **tilde-transport** route that bypasses `gstar_transpose` at the affine-local
  level (the structurally-different fallback). This needs (a) a new blueprint section authored first
  (blueprint-writer), then (b) a scaffold (lean-scaffolder). Gate any FBC prover on that blueprint via the
  HARD GATE. The user has been asked (TO_USER.md) to steer whether to pursue tilde-transport vs park FBC;
  the loop proceeds on other lanes regardless.
- The new sub-blocker (the `(pushforwardComp g' (Spec φ)).hom` factor is `rfl`-`𝟙` yet resists `simp`/`rw`
  asymmetrically with `.inv`; needs a diamond-safe `change`/`conv`, not `erw`) is documented inline at the
  sorry and in milestones — not worth a dedicated round on its own.

## §1 — Coverage debt: 4 new `lean_aux` helpers need blueprint blocks (MEDIUM)
`archon dag-query unmatched` = 4. These prover-created QUOT helpers have NO blueprint entry (invisible to
the dependency graph). The review agent does not author prose — the planner should blueprint each:
- `Scheme.Modules.image_basicOpen_of_affine` — depends on `Scheme.image_basicOpen`, `basicOpen_eq_of_affine`.
- `Scheme.Modules.compositeBasicOpenImmersion_image_basicOpen` — instantiation of the above at the composite
  immersion.
- `Scheme.Modules.image_basicOpen_eq_inf` — depends on `image_basicOpen_of_affine`, `Scheme.basicOpen_res`.
- `Scheme.Modules.section_localization_hfr_aux` — the heavy opaque-`j` core; depends on
  `isLocalizedModule_powers_transport`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`,
  `gammaPullbackImageIso_hom_semilinear`/`_naturality`, `Scheme.Hom.appIso_inv_naturality`,
  `Scheme.Modules.map_smul`, `IsLocalizedModule.of_linearEquiv(_right)`.

## §2 — Blueprint pin mismatches on the gap1 chain (MEDIUM — planner to resolve, NOT a review re-pin)
The leandag `frontier` shows 3 QUOT blocks still "unproved" because their `\lean{}` pins name decls that
do NOT exist, while the actually-built decls are the unmatched `lean_aux` nodes above. The review agent did
NOT re-pin these (following the iter-040 doctrine: re-pinning a bundled block lets `sync_leanok` falsely
`\leanok` a multi-claim block). Planner decisions owed:
- `lem:composite_immersion_flocus_basicOpen` (~tex line 4339) pins `compositeBasicOpenImmersion_flocus_image`
  (nonexistent). The built `compositeBasicOpenImmersion_image_basicOpen` proves only the IMAGE half; the
  block ALSO bundles `σ(f') = algebraMap R R_s f`. **SPLIT the block** (image-identity vs σ-identity) before
  re-pinning, or the block stays honestly unmarked. (Same hazard the iter-040 review flagged for the range
  block.)
- Blocks pinning `isLocalizedModule_basicOpen` (~2478) and `isLocalizedModule_basicOpen_of_isQuasicoherent`
  (~2718) name decls that don't exist — decide whether these are legacy/alternative formulations to retire
  or to re-point at the built `section_localization_hfr_basicOpen` / `isIso_fromTildeΓ_of_isQuasicoherent`.
  (The keystone `isLocalizedModule_basicOpen_descent` @4105 and gap1 `isIso_fromTildeΓ_of_isQuasicoherent`
  @4215 ARE correctly pinned and now proved.)

## §3 — QUOT next: ride the gap1 unblock (HIGH — the throughput win)
gap1 (`isIso_fromTildeΓ_of_isQuasicoherent`) now unblocks: **G1-core / GF-G1**
(`gf_qcoh_fintype_finite_sections`), the **annihilator forward direction** (the reverse `≥` inclusion of
`Scheme.Modules.annihilator`), and the next QUOT sub-build **P2**. These are the ready frontier — prioritize
them. In particular the lvb-checker flagged (MAJOR) that **G1-core**
(`isLocalizedModule_basicOpen_of_isQuasicoherent`, blueprint block `lem:qcoh_affine_section_localization`
@~tex 2718) is now a **2-line corollary** of gap1 (via `isIso_fromTildeΓ_of_isQuasicoherent` +
`isLocalizedModule_restrict_of_isIso_fromTildeΓ`) — schedule it as a near-term objective and strip the
block's now-outdated `% NOTE: does NOT yet exist. G1-core is now a DOWNSTREAM COROLLARY` once built. The progress-critic's standing QUOT OVER_BUDGET flag (~14 iters on gap1) is now resolved by closure;
the lane converged.

## §4 — Reusable proof patterns landed (reference; recorded in PROJECT_STATUS Knowledge Base)
- **Opaque-immersion device** (the gap1 close): push a heavy `IsLocalizedModule` assembly whose final
  form-coercion mentions a concrete composite open immersion into a helper taking the immersion as an
  OPAQUE hypothesis (`rfl` there; >3.2M-heartbeat `whnf` runaway when concrete); instantiate in a thin
  wrapper. Mirrors `image_basicOpen_of_affine`. Also: open-transport across `eqToHom` opens via
  `IsLocalizedModule.of_linearEquiv_right`/`of_linearEquiv` + a forward naturality square (NOT
  `ModuleCat.hom_ext`).

## §5 — Dashboard caveat to relay (LOW)
The generic-flatness algebraic route (incl. axiom-clean `genericFlatnessAlgebraic`) may show 0 `\leanok` on
the dashboard due to a `sync_leanok` single-file `lake env lean` quirk, not a regression — confirm GF status
via `lean_verify`/`lake build`, not the marker count. (Carried over from the prover's `.archon/TO_USER.md`
note; not surfaced on the root banner to keep it ≤3 bullets.)

## §6 — Hilbert-polynomial encoding caveat (LOW, now ungated)
The canonical `Φ_s` likely needs a Serre `m≫0` agreement; the "Hartshorne II.5.17" attribution is
unverified. Now that gap1 landed this is ungated — when the QUOT lane reaches the Hilbert-poly encoding,
fetch the right reference (reference-retriever) rather than relying on the unverified attribution.
