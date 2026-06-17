# Blueprint-writer directive — iter-256 — chapter `Picard_TensorObjSubstrate.tex`

You own ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Make exactly the two
proof-sketch refinements below (a per-file Lean↔blueprint check found the current sketches
under-specified for the prover). Do NOT touch any other block, any `\leanok`/`\mathlibok`
marker, or any other chapter. Keep all existing `% SOURCE:` / `% SOURCE QUOTE:` lines intact.

## Fix 1 — `lem:sheafofmodules_hom_of_local_compat` proof, sub-step (c)
The proof currently lists sub-step (c) (the sectionwise `𝒪_X`-linearity check) as "mechanical".
It is NOT mechanical. Replace the (c) description with a three-part bullet that records the real
obstacle the formalization hit:
- (c.i) The M-leg semilinearity is discharged by `Scheme.Modules.map_smul M` (the native
  Γ-module-level statement `M.presheaf.map i.op (r•x) = X.presheaf.map i.op r • M.presheaf.map i.op x`,
  no `restrictScalars` artifact) — closes cleanly.
- (c.ii) The f-leg obstacle: `(f i).val.app P` is linear over the `restrictScalars (𝟙)` action
  `((M.restrict (U i).ι).val.obj (op P))`, whereas the goal's f-leg input action is the *native*
  `Γ(X, image)`-module action. These are propositionally equal but NOT definitionally equal, because
  the open-immersion structure-ring iso is the identity: `(U i).ι.appIso = Iso.refl`, so the restrict
  ring map is `𝟙`, and `ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App` identify
  `c •_{restrictScalars 𝟙} x = 𝟙 c • x = c •_native x`. This identity-ring-map smul bridge is the
  genuine content of (c).
- (c.iii) The N-leg is then discharged by `Scheme.Modules.map_smul N` once the bridge is in place, and
  the transported scalars reconcile because the two open-set `eqToHom` maps compose to the identity on
  the overlap (`(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ W) = W`).
State this as mathematics (a localization/identity-ring-map identification of module actions), not as
Lean tactic strings; you may name the Mathlib lemmas as the tools used, as the existing chapter does.

## Fix 2 — `lem:dual_restrict_iso` proof, Step 4
The Step-4 sketch currently presents a clean "Leg (A) Beck–Chevalley slice Hom base-change" + "Leg (B)
ground-ring reconciliation" decomposition, but the formalization first performs an adjunction-uniqueness
rewrite that the sketch omits, so a prover following the sketch hits a mismatch. Update Step 4 to a
two-stage description:
- Stage H1 (currently unnamed): use the uniqueness of left adjoints
  (`pushforwardPushforwardAdj` composed with `leftAdjointUniq`) to rewrite the pulled-back dual
  `pullback φ`-form into a `pushforward β`-form. After H1 the residual obligation is exactly
  `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` — "pushforward β commutes with
  dual".
- That residual is then the sectionwise composite of the original Leg (A) (the slice-site/domain
  comparison) and Leg (B) (the ground-ring iso transport via `restrictScalarsRingIsoDualEquiv`). Make
  clear the Leg (A)/(B) content is what remains AFTER H1, not a standalone two-leg split of the whole
  Step 4.

## Also (formatting cleanup, non-marker)
This chapter previously had stray `\leanok` control sequences erroneously embedded inside several
`\uses{...}` argument lists; those were removed by the planner. Do not re-introduce any `\leanok`
anywhere. When you edit the two proof blocks above, keep every `\uses{...}` argument on lines that
begin with a label token (never a control sequence).

## Out of scope
- D1'/D2'/D3'/D4' blocks (already adequate). The `homLocalSection`, `dual_unit_iso`,
  `dual_isLocallyTrivial` blocks. Any marker. Any other chapter. References are likely unneeded
  (these are Archon-original sub-steps); only fetch a source if you find an unsupported external claim.
