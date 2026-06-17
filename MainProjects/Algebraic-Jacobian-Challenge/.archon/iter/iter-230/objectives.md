# Iter-230 objectives detail

## Lane TS — `Picard/TensorObjSubstrate.lean` (mode: prove) — THE CONVERGENCE TEST

### Context
iter-229 landed the shared root `AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv` axiom-clean
(the open-immersion↔slice sheaf-site equivalence `Sheaf ((Opens.grothendieckTopology X).over U) A ≌
Sheaf (Opens.grothendieckTopology ↥U) A`, value-cat-parametric `A`, via `Equivalence.sheafCongr`).
The route's reframe ("both ⊗-inverse bridges reduce to this one root") is now testable in Lean.

This iter is the **decisive convergence datapoint**: wire the root into a consumer and move the
project sorry counter **80→79** by closing `exists_tensorObj_inverse` (L2143).

### PRIMARY (the binding probe) — `dual_isLocallyTrivial`
Target decl: `AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial` (blueprint
`lem:dual_isLocallyTrivial`).

Statement: for `L : X.Modules` with `LineBundle.IsLocallyTrivial L`, the sheaf-level dual
`Scheme.Modules.dual L` is again locally trivial of rank one.

Recipe (blueprint `lem:dual_isLocallyTrivial` proof + iter-229 prover handoff):
- Steps 1–3 + H1 run verbatim from `tensorObj_restrict_iso` (both `dual L` and `M ⊗ N` are
  `sheafification.obj` of a presheaf): reduce restriction to the abstract pullback
  (`restrictFunctorIsoPullback`); move the pullback inside sheafification
  (`sheafificationCompPullback`); strip the outer sheafification (`.mapIso`); H1 identifies
  `pushforward β ≅ pullback φ` (`pushforwardPushforwardAdj` + `Adjunction.leftAdjointUniq`).
- The post-H1 residual is `(pushforward β).obj (dual A) ≅ dual ((pushforward β).obj A)` (open-immersion
  pushforward commutes with the presheaf dual). This is the slice-internal-hom mismatch that iter-228
  empirically falsified the "verbatim mirror" claim on. **Discharge it with the shared root
  `overSliceSheafEquiv` (value cat `A := ModuleCat _`) composed with the ModuleCat-level shadow
  `restrictScalarsRingIsoDualEquiv`.**
- Then `(dual L)|_U ≅ dual (L|_U) ≅ ℋom_{𝒪_U}(𝒪_U, 𝒪_U) ≅ 𝒪_U` (last step = evaluation at 1).

**First read the dual/internalHom block (~L1602–2050) to fix the EXACT type `dual_isLocallyTrivial`
carries against `Scheme.Modules.dual`** (iter-229 prover handoff explicitly flags this).

#### ⚠ BINDING WATCH (strategy-critic ts230) — REPORT WHICH OUTCOME
The shared root is value-cat-FIXED `Sheaf J A ≌ Sheaf K A`. It does NOT transport the C-bridge's
**varying-ring `𝒪_X(U)`-module action** for free. When composing it with the `restrictScalars`
transport, exactly one of:
- **(i) clean compose** — the fixed-value-cat root + `restrictScalarsRingIsoDualEquiv` discharge the
  residual with only thin-poset `Subsingleton.elim` naturality. → WATCH resolved, block converges.
- **(ii) forced re-derive** — closing the residual forces re-deriving the equivalence at the
  ModuleCat-over-varying-ring **module fibration** (a re-build, not a compose-with-shadow). → the 4th
  cost growth has materialized; the "one shared root unblocks both" framing is falsified for C.

**State explicitly in the task result which of (i)/(ii) occurred.** If (ii): STOP at a precise
decomposition (what the module-fibration equivalence must be; what it reduces to) — do NOT stub, do
NOT pin a sorry, do NOT force a shortcut.

### SECONDARY (only if C is clean) — `homOfLocalCompat`
Target decl: `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` (blueprint
`lem:sheafofmodules_hom_of_local_compat`). Value cat **Type** — the CLEAN case (no varying-ring
transport; strategy-critic ts230 confirms the risk is not here).

Recipe: `presheafHom (M.val.presheaf) (N.val.presheaf)` is a sheaf of types (`Presheaf.IsSheaf.hom`,
consuming N's sheaf condition) → regard as `TopCat.Sheaf` → `existsUnique_gluing` amalgamates the
compatible local sections → `presheafHomSectionsEquiv`/`sheafHomSectionsEquiv` lands the ⊤-section as
a genuine presheaf morphism `g` → `homMk` re-attaches 𝒪_X-linearity. Build `localSection i` + its
**naturality field** (the one real coherence risk — the section-direction slice of `overSliceSheafEquiv`,
controlled by the down-set identity `ιᵢ(ιᵢ⁻¹ V) = V` for `V ≤ Uᵢ`, coherence by `Subsingleton.elim`)
as a standalone axiom-clean lemma FIRST. Remaining sub-steps (cocycle/IsCompatible from the assumed
overlap-agreement; glue+convert; sectionwise linearity; restriction-recovery) are mechanical.

### THEN — close `exists_tensorObj_inverse` (L2143), 80→79
Per `rem:dual_discharges_inverse`: `L⁻¹ := dual L` (a line bundle by PRIMARY). The global contraction
`ε_L : L ⊗_X L⁻¹ → 𝒪_X` is built by **gluing the canonical local contractions** (NOT by sheafifying
the presheaf eval — that re-hits `M ◁ η` whiskering = d.2 DEAD END): on each trivialising `U`,
`tensorObj_restrict_iso` carries `(L ⊗ L⁻¹)|_U` to `𝒪_U ⊗_U 𝒪_U`, and the local contraction is the
left unitor `tensorObj_unit_iso` (an iso). These local contractions are canonical → agree on overlaps
→ glue via `homOfLocalCompat`; the glued morphism is a global iso by the B-connector
`isIso_of_isIso_restrict`. That supplies the inverse, closing the sorry.

### Reuse (do NOT re-derive)
`overSliceSheafEquiv` + `overEquivInverseIsDenseSubsite` (shared root), `tensorObj_restrict_iso`,
`Scheme.Modules.dual`, `isIso_of_isIso_restrict` (B), `homMk` + `toPresheaf_map_homMk` (A step ii),
`restrictScalarsRingIsoDualEquiv` (C shadow), the 3 dual-iso helpers (`dualPrecompEquiv`, presheaf +
scheme `dualIsoOfIso`), the H1 `pushforwardPushforwardAdj` apparatus, `tensorObj_unit_iso`.

### Success bar — HARD TRIPWIRE (progress-critic ts230)
Project sorry **80→79** (`exists_tensorObj_inverse` closed; build GREEN; `lean_verify` axiom-clean
`{propext, Classical.choice, Quot.sound}`). A consumer landing WITHOUT the 80→79 close repeats the
iter-229 pattern and does NOT clear the tripwire. If 80→79 fails: report the precise blocker (which
C-outcome (i)/(ii); exactly where the assembly stalls). Partial progress from a real attempt (the
C-wiring diagnostic, a compiling sub-lemma) >> a clean typed-sorry pin. Do NOT stub.

### FORBIDDEN this iter
Pinning a NEW sorry; the sheafify-the-presheaf-eval/associator shortcut (d.2 dead end);
building/pinning `isLocallyInjective_whiskerLeft_of_W` (L659, vestigial d.2); sectionwise flatness;
touching `addCommGroup_via_tensorObj` (RPF consumer, downstream); `set_option maxHeartbeats`; the
14-site `Sheaf.val`→`ObjectProperty.obj` deprecation migration.

## All other lanes — HELD/paused (unchanged)
Route C (RR chain) PAUSED (USER); A.2.c engine HELD behind TS→RPF; Route 2 gated A.2.c; RPF held
pending the ⊗-group law; Route-1 Albanese cone EXCISED. No dispatch.
