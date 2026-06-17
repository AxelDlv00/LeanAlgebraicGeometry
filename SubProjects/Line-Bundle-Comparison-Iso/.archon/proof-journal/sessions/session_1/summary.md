# Session 1 (iter-001) — Review Summary

## Metadata
- Iter/session: 001 / session_1. First prover round on this extracted subproject.
- Sorry count: **DualInverse.lean 5→4**; TensorObjSubstrate.lean 3→3. Total active code sorries: 7
  (DualInverse {388,525,627,629}; TensorObjSubstrate {712,2623,2851}).
- Build: was BROKEN on entry (DualInverse non-compiling) → GREEN after restore. sync_leanok ran
  (iter 1, +50 markers, sha edf4866) ⇒ markers reflect current tree.
- Targets touched: DualInverse DUAL-chain (5 fields) + §C tail restore; TensorObjSubstrate D3′
  cocycle (`comp_tail`) + `pullbackTensorMap_restrict`. `exists_tensorObj_inverse` untouched (per objective).

## Headline deliverables
1. **DualInverse.lean restored from broken → compiling.** On entry the committed file did NOT
   compile (`error: unterminated comment, line 888`). The extraction's Lean-decl remover truncated
   the entire §C tail mid-`/-- … -/` docstring, dropping `homLocalSection`, `topSectionToHom`,
   `topSectionToHom_app`, `homOfLocalCompat` and leaving a dangling docstring that broke the whole
   downstream cone (incl. `RelPicFunctor`). Prover confirmed lines 1–849 byte-identical to the
   extraction parent and restored the full tail from
   `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.../DualInverse.lean`. Restored
   tail is sorry-free. **This unblocked the entire downstream cone.**
2. **`dual_restrict_iso` outer isoMk naturality CLOSED** (was L760) with a one-line `subsingleton`.
   `refine PresheafOfModules.isoMk (fun V => sliceDualTransport f M V) ?_; intro V W g; subsingleton`.
   `dual_restrict_iso`'s own body is now sorry-free (inherits `sliceDualTransport` residual only
   transitively). Sorry 5→4.

## Per-target detail

### SOLVED — `dual_restrict_iso` isoMk naturality (DualInverse L760)
- `subsingleton` closes the module-map equality: the connecting Hom-space is dual-valued
  (maps into the unit) over the thin poset `Opens Y`, hence a `Subsingleton`.
- ⚠ Auditor caveat (lean-auditor-iter001, MAJOR): the close uses the opaque `subsingleton` tactic
  on a *module-map* equality, whereas the file's other `Subsingleton.elim` uses (L888/891/1097/1107)
  are on morphisms IN the thin poset. The lean-vs-blueprint-checker confirms the blueprint justifies
  the dual-valued/thin-poset Subsingleton, so this is very likely genuine — but it should be
  re-verified that the instance fires independently of the still-open `sliceDualTransport.hom`
  sorries. See recommendations.

### BLOCKED — `sliceDualTransport.toFun.naturality` (L525)
- `subsingleton` FAILS: `could not synthesize Subsingleton ((restr V (pushforward β M.val)).obj A ⟶
  (restrictScalars …).obj ((restr V 𝟙_).obj B))` — codomain is a *restriction of the unit* (not
  dual-valued), genuinely not a subsingleton.
- `intro A B f1; apply ModuleCat.hom_ext; refine LinearMap.ext fun z => ?_` reduces correctly to the
  pointwise scalar/ε-commutation equation, but closing needs the multi-step ε-naturality `erw` paste
  (`PresheafOfModules.restrictScalarsLaxε` + `NatTrans.naturality` along the structure-ring iso).
  NOT a few-call closure. Frontier open since parent iter-262.

### BLOCKED — `sliceDualTransportInv.naturality` (L388)
- Mirror of L525. `subsingleton` fails identically. `apply PresheafOfModules.hom_ext` fails to unify
  (`could not unify conclusion ?f = ?g with the component-level goal`). `app` field is axiom-clean
  (parent iter-303); only naturality remains. Same ε-paste needed.

### BLOCKED — `sliceDualTransport.left_inv` / `.right_inv` (L627 / L629)
- Goal-shape confirmed only (per fine-grain budget). `invFun` is wired to the restored
  `sliceDualTransportInv` (L616). `left_inv` needs `dualUnitRingSwap`/ε round-trip cancellation +
  the down-set bijection `image_preimage_of_le`; defeq-delicate, blocked on `sliceDualTransportInv`.
  `right_inv` is the `Iso.hom_inv_id` mirror.

### BLOCKED — `sheafificationCompPullback_comp_tail` (TensorObjSubstrate L2623)
- The composite-adjunction-unit **cocycle**. Forward steps already land (`restrictScalarsId_map`
  strip → `Functor.map_comp` distribution → `forget_map_pushforward_map` bridge → `hwr` staged via
  `conjugateEquiv_whiskerRight` → `simp [Adjunction.comp_unit_app]`). Residual goal
  `B_{h≫f}.unit.app P = cocycle`.
- `rw/erw [leftAdjointUniqUnitEta_app f P]` (both directions): `rewrite failed: did not find pattern`
  — the `A_f.homEquiv (sheafCompPb f).hom.app P` head is consumed by `(pullback h).map ∘ forget.map`
  wrapping. `simp only [← Functor.map_comp, Adjunction.unit_naturality, pushforwardComp_hom_app_app]`:
  no progress (all args unused). Matches parent iter-303 finding.
- **Recommended next (NOT fine-grain):** cross-domain mate-assembly escalation per
  `analogies/d3-mate271.md` — consume `hwr` via the surjective/injective reduction of
  `leftAdjointCompNatTrans_assoc` (`CompositionIso.lean:155`), or re-prove
  `sheafificationCompPullback_comp` wholesale (Mathlib's `pullback_assoc` pattern). ~40–60 LOC.

### BLOCKED (gated) — `pullbackTensorMap_restrict` (L2851)
- Opened to the paste-ready 4-square form (`simp only [pullbackTensorMap, tensorObjIsoOfIso]` +
  three `Functor.map_comp` + `Category.assoc`). Not advanced further: its Sq1 input is `comp_tail`,
  which did not close. Do not re-assign until `comp_tail` lands.

### NOT STARTED (intentional) — `exists_tensorObj_inverse` (L712)
- Untouched per objective. Its inverse `L⁻¹ := dual L` is supplied by the DUAL chain downstream;
  closing it here would create an import cycle. Closes once the DUAL chain lands.

## Subagent findings (this iter)
- **lean-auditor (iter001)**: 0 must-fix, 2 major, 3 minor. Both files structurally sound; all 7
  sorries have clean bodies (no fake structure); §C restored tail complete + axiom-clean; no
  excuse-comments. Major findings are stale/contradictory comments (see recommendations).
  Report: `task_results/lean-auditor-iter001.md`.
- **lean-vs-blueprint-checker (dualinverse)**: 0 must-fix, 1 major. 16/16 pinned decls verified
  correct, signatures + proofs match blueprint, hints precise. Major: `homOfLocalCompat` (restored,
  ~170 LOC, sorry-free) has NO blueprint `\label`/`\lean{}` pin — coverage gap.
  Report: `task_results/lean-vs-blueprint-checker-dualinverse.md`.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `rem:dual_discharges_inverse` (~L5256): added a `% NOTE`
  flagging that the A-bridge `homOfLocalCompat` is referenced in prose only and has no formal
  blueprint block/`\lean{}` pin (coverage gap for the planner's blueprint-writer).
- No `\leanok` overrides: `dual_restrict_iso` proof block correctly carries no proof-`\leanok`
  (transitively depends on open `sliceDualTransport` sorries) — sync_leanok's verdict is right.
- No `\mathlibok` added: no newly-referenced Mathlib-backed leaf decls.
- No `\lean{...}` corrections: checker confirms all 16 pins are correct; no renames.
- No stale `\notready` to strip (none present).

## Blueprint-doctor findings (surfaced)
Doctor flagged broken `\cref` targets to chapters dropped in the extraction (no `\label` exists):
`chap:Jacobian`, `chap:Picard_RelativeSpec`, `chap:Picard_FGAPicRepresentability`,
`chap:Albanese_AlbaneseUP`, `chap:Picard_IdentityComponent` (across `Picard_LineBundlePullback.tex`,
`Picard_RelPicFunctor.tex`, `Picard_TensorObjSubstrate.tex`). Cosmetic dangling cross-refs; planner
should redirect or strip. See recommendations.

## Notes
- LOW: minor stale comments — `LineBundlePullback.lean:220` (calls `IsLocallyTrivial.pullback` a
  "named typed sorry" though it's fully proved at L156-193); `Vestigial.lean:15-16` (header claims
  `isLocallyInjective_whiskerLeft_of_W` has an open sorry though it's closed, parent iter-237).
