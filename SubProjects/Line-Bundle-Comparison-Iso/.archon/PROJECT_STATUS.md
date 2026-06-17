# Project Status

This file was reset on extraction into the **Line-Bundle Comparison Iso**
subproject. The parent's accumulated iteration narrative (iter-099…iter-303,
much of it about files now out of scope) was dropped; this subproject's own
`archon` run regenerates status as it makes progress. Per-iter narrative lives
in `iter/iter-NNN/review.md`; this file carries the cumulative Knowledge Base only.

Current scope and live state live in [`PROGRESS.md`](PROGRESS.md) and
[`STRATEGY.md`](STRATEGY.md). Summary:

- **Seeds:** `lem:pullback_tensor_iso_loctriv`, `lem:dual_isLocallyTrivial`,
  `thm:rel_pic_addcommgroup_via_tensorobj` (108-node cone).
- **Open targets (post iter-007):** TensorObjSubstrate.lean GREEN, 2 sorries —
  `exists_tensorObj_inverse` (L712, import-cycle, deferred) and `pullbackTensorMap_restrict`
  (L3144, residual Sq3/Sq4 interleave). `sheafificationCompPullback_comp_tail`/`_comp`/`_comp_natTrans`/`hδ`
  all CLOSED iter-006. DualInverse.lean now **GREEN** (RED deadlock broken iter-007: repaired+split,
  `sliceDualTransport` machinery moved to `DualInverse/SliceTransport.lean`). SliceTransport.lean
  GREEN, **3 sorries**: `sliceDualTransportInv.naturality` (L444 ROOT), `sliceDualTransport`
  left_inv (L724) / right_inv (L726). Forward `sliceDualTransport.toFun.naturality` CLOSED iter-007.
- **Stage:** prover.

## Knowledge Base

### Proof Patterns (reusable across targets)
- **Composite-adjunction cocycle at the NatTrans level (the D3′ keystone — CLOSED iter-006):** prove
  the whole-transformation equation, NOT the `.app P` component — the dependent `eqToHom`/reindex junk
  that blocks every `rw` exists ONLY post-`.app`. Build it from `Adjunction.leftAdjointCompNatTrans_assoc`
  (Mathlib `CompositionIso.lean`) instances with outer comparisons trivialized via `conjugateEquiv_symm_id`;
  evaluate `.app P` exactly ONCE at the end. To close a *consumer* (`comp_tail`): take the `P`-component
  of the NatTrans lemma (= the caller's statement), transpose FORWARD via `homEquiv`, and replay the
  caller's reduction script **`at` the hypothesis** (not the goal). Mirrors the project's own working
  `pullbackObjUnitToUnit_comp`. Recipe: `analogies/d3cocycle006.md`.
- **`erw` for cross-elaboration / `Sheaf.val`-spelled / `show`-pinned rewrites (D3′ region):** a term
  elaborated standalone (e.g. simp lemma `J1`, a `show`-pinned `δfh`) carries a hidden instance-level
  defeq mismatch with the same term elaborated inside a `leftAdjointCompNatTrans_assoc` paste —
  `rw`/`simp only` silently no-op (watch for the unused-simp-arg warning); `erw` defeq-matches. The
  leftover `𝟙`-junk sits at a defeq-but-not-syntactic object spelling, so `Category.id_comp` also needs
  `erw`. ⚠ `erw [Functor.map_comp]` on an oplax `δ` catastrophically UNFOLDS it into its mate expansion —
  never. To fold instead, `rw [← Functor.map_comp]` (explicit `aZ.map _ ≫ aZ.map _` heads match) then
  `exact congrArg aZ.map …`. Pre-elaborate context-sensitive instances (`IsLocallyInjective (𝟙 …)`)
  via a private abbrev (`sheafifyIdOf`) so a multi-scheme statement doesn't re-run synthesis.
- **Thin-poset `subsingleton` close (dual-valued only):** an `isoMk` naturality square whose
  connecting Hom-space is *dual-valued* (maps into the unit) over a thin poset (`Opens Y`) is a
  `Subsingleton`; `subsingleton` closes it in one line (e.g. `dual_restrict_iso` isoMk naturality,
  DualInverse ~L786). ⚠ It does NOT close a square whose codomain is a *restriction of the unit*
  (`sliceDualTransport.naturality` L553, `sliceDualTransportInv.naturality` L407) — that codomain is
  not a Subsingleton; `subsingleton` errors `could not synthesize Subsingleton (… ⟶ …)`. The two
  cases look identical but differ in codomain. Verify the instance is genuine (not sorry-induced)
  before trusting an opaque `subsingleton`; prefer `exact Subsingleton.elim _ _`.
- **Slice-transport naturality via pointwise `_apply` rotation (CONFIRMED iter-007 — closed the
  forward `sliceDualTransport.toFun.naturality`; OVERTURNS the old `restrictScalarsLaxε` recipe):**
  the naturality field reduces (via `intro …; apply ModuleCat.hom_ext; refine LinearMap.ext fun z => ?_`)
  to a pointwise ε-commutation equation. Do NOT close it with a `restrictScalarsLaxε` natTrans (the
  prover never found/used one). Instead: (1) EXTRACT a standalone sorry-free lemma
  `sliceDualTransport_naturality_apply` — the parent def is at its heartbeat limit, so it cannot be
  proved inline; (2) close the square pointwise via `appIso_hom_naturality_apply` (ring-level
  naturality of `(f.appIso).hom`) + `dualUnitRingSwap_apply`/`dualUnitRingSwapHom_apply` (the `inv ε`
  legs evaluated WITHOUT `whnf`) + `PresheafOfModules.naturality_apply` of the dual section at the
  `f`-image of `f₁`; (3) delegate the field to it. The inv direction (`sliceDualTransportInv`) is the
  mirror — same extraction, plus `unitRelabelSwap` for the codomain unit and the `hβ` ring-compat
  hyp discharged by `Iso.hom_inv_id`. ⚠ Applying `inv ε` pointwise through `whnf` reproduces the
  ≥6-iter deterministic-timeout (seen again iter-007) — always route through the proven `_apply` lemmas.
- **Composite-adjunction-unit cocycle (do not fine-grain):** `sheafificationCompPullback_comp_tail`
  is an irreducible mate-assembly; whiskered comparison factors (`(pullback h)`-whiskered /
  `forget`-wrapped) expose no `homEquiv` head for `leftAdjointUniqUnitEta_app`. Consume the staged
  `hwr` (`conjugateEquiv_whiskerRight`) via the surjective/injective reduction of
  `leftAdjointCompNatTrans_assoc` (`CompositionIso.lean:155`), mirroring Mathlib's
  `SheafOfModules.pullback_assoc`. ~40–60 LOC; a cross-domain escalation, not a helper round.
- **Unit-swap pointwise helper:** `dualUnitRingSwap_apply` proves
  `(dualUnitRingSwap f W').hom x = (Scheme.Hom.appIso f W').hom.hom x` by composing with the inverse
  appIso map and using injectivity + `hom_inv_id`. Use this helper rather than unfolding the lax unit
  inside large structure fields.
- **D3 associativity scaffold:** For `sheafificationCompPullback_comp`, instantiate
  `Adjunction.leftAdjointCompNatTrans_assoc` with `τ012`/`τ013` identity-shaped forget/pushforward
  comparisons, `τ123 = SheafOfModules.pushforwardComp.inv`, `τ023` the forget-whiskered
  `PresheafOfModules.pushforwardComp.inv`, and `hτ := by ext A; rfl`. Pin pushforward universes as
  `.{u}`; `Adjunction` has no `.right`/`.rightAdjoint` projection.

### Known Blockers (do not retry without a structural change)
- ~~**`DualInverse.lean` is RED**~~: RESOLVED iter-007 (repaired to GREEN + split into
  `DualInverse/SliceTransport.lean`; forward naturality then closed). The DUAL chain is now an
  ordinary proving task, not a regression. Dead approaches that remain DEAD: `ext z`+`exact hφ z`
  (applies an equality as a function); pointwise `ext z; simp [dualUnitRingSwap_apply]` / any
  `inv ε` through `whnf` (the ≥6-iter deterministic-timeout, reproduced again iter-007). Use the
  pointwise `_apply` rotation pattern above instead.
- `pullbackTensorMap_restrict` (L3144): `comp_tail` gate is LIFTED (closed iter-006); the residual is
  the Sq3/Sq4 interleave — `sheafifyTensorUnitIso` (Sq3) and `pullbackValIso` (Sq4) composition
  coherences, both Mathlib-absent sub-lemmas not yet constructed. This is project-lemma construction
  (effort-breaker candidate), not a tactic gap. Sq4 reduces to CLOSED `sheafificationCompPullback_comp` + counit naturality.
- `exists_tensorObj_inverse` (L712): import-cycle — closes downstream via the DUAL chain, never by
  direct assignment.
- ~~`sheafificationCompPullback_comp_tail`~~ / ~~`_comp`~~: CLOSED iter-006 (NatTrans-cocycle pattern above).
- `sliceDualTransport.naturality`: CONFIRMED iter-007 — do NOT inline the elementwise proof in the
  monolithic `LinearEquiv` (it closes in isolation but pushes later fields past heartbeat limits).
  Factor into a standalone helper (`sliceDualTransport_naturality_apply`) and call it from the field.
  The forward direction is now CLOSED this way; the inv-naturality root (L444) awaits the same mirror.
- `sheafificationCompPullback_comp`: do not retry raw `aesop_cat`, reassociation, `← Functor.map_comp`,
  or sectionwise `hom_ext`. The remaining blocker is the mixed comparison
  (`sheafificationCompPullback h` followed by sheafified `PresheafOfModules.pullbackComp.hom`) and
  functor-associator cleanup.

### Extraction mechanics (non-obvious gotchas)
- **Confirmed truncation bug:** the extraction's Lean-decl remover truncated DualInverse.lean's
  entire §C tail mid-`/-- … -/` docstring, committing a non-compiling file (`unterminated comment`)
  that broke the whole downstream cone. The parent repo
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/` is the last-known-good source
  of truth: diff the byte-identical prefix and restore the lost tail. **Other extracted files may be
  similarly truncated — worth a one-shot sweep.**

## Last Updated
2026-06-13T02:50:34Z (iter-009 review — no KB change; iter-009 was a SECOND consecutive prover-model
(`fable`) capacity failure: both lanes died at session start with 0 tokens, 0 events, state carried
unchanged from iter-007. Model-switch escalated to user via TO_USER.md — loop cannot self-heal
(config.json is user-only). Directives re-queued verbatim.)
