# Blueprint-writer directive — Cohomology_CechHigherDirectImage.tex

Target chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated;
`% archon:covers` includes `CechSectionIdentificationLeg.lean`).

The chapter is **silent on the last open CSI leaf** `pushPull_interLegHom_sections`
(`CechSectionIdentificationLeg.lean:1003`), the sole gap blocking a prover dispatch on that
file. The full Lean proof route already exists (developed + scratch-compiled by the prover);
your job is to transcribe it as rigorous **mathematical** prose (textbook level, NO Lean
tactics, NO `\leanok`). All blocks below are **project-bespoke open-immersion-pushforward
naturality** — no external source, omit `% SOURCE` lines; they stand on the proof sketch.

## Actions

### 1. Add block `\label{lem:pushPull_interLegHom_sections}` (MUST-FIX — the gate)
Place it BEFORE `lem:coreIso_comm_leg` (currently ~L8806). Verbatim Lean signature to pin:

```
\lean{AlgebraicGeometry.pushPull_interLegHom_sections}
```
Statement (in project notation): fix the finite cover `𝒰`, `F : X.Modules`, open `V ⊆ X`,
degree `p`, multi-index `σ' : Fin(p+2) → I`, coface index `k`. Let
`interLegHom 𝒰 σ' k : Over.mk j_{σ'} ⟶ Over.mk j_{σ'∘δᵏ}` be the over-morphism whose underlying
map is the open immersion `c : U_{σ'} ⊆ U_{σ'∘δᵏ}` (intersection opens). Through the per-leg
section identifications `pushPull_leg_sections` (Lemma `lem:pushPull_leg_sections`) at source and
target, the section-at-`V` of the push–pull map `G_V(Ψ(interLegHom))` equals the plain
`F`-restriction along `U_{σ'} ⊓ V ⊆ U_{σ'∘δᵏ} ⊓ V`:
\[ (\mathrm{ev}_V \Psi)\,\mathrm{pushPullMap}(F,\mathrm{interLegHom})\cdot
   \mathrm{pls}(σ').\mathrm{hom} = \mathrm{pls}(σ'\circ δ^k).\mathrm{hom}\cdot
   \mathcal F(\mathrm{homOfLE}). \]

Proof sketch (`\uses{lem:pushPull_leg_sections, lem:pushPull_leg_coherence}` + the Mathlib
mate-calculus facts named below). Write it as a 4-step argument:
- **(a) Per-leg coherence.** By `lem:pushPull_leg_coherence`, for an over-morphism
  `Over.homMk c` with `c` an open immersion, `pushPullMap F (Over.homMk c)` equals the pushforward
  of the restriction-adjunction unit `q_*(η^c_{q^*F})` post-composed with the canonical leg iso
  `pushPullLegIso`. So `interLegHom` reduces to the restriction unit along `c`.
- **(b) Unit ↔ pullback comparison.** The restriction-adjunction unit composed with the
  pushforward of the comparison iso `restrictFunctorIsoPullback` (rFIP, the `leftAdjointUniq`
  between the restriction and pullback adjunctions) IS the pullback–pushforward adjunction unit
  (Mathlib `Adjunction.unit_leftAdjointUniq_hom_app`).
- **(c) Composition law along `c ≫ q`.** The unit of the composite restriction/pullback factors
  through the units of the pieces via the comparison isos `pullbackComp`/`restrictFunctorComp`
  (naturality squares; the "inner β" naturality chain). This identifies
  `pushPullMap F (Over.homMk c) ≫ (inverse target leg-iso)` with the chain of pushforwards of the
  restriction unit, transported by the `Congr` isos at the defining equality `c ≫ q = pC`.
- **(d) On sections over `V`.** The restriction-adjunction unit acts on sections as the plain
  presheaf restriction `F.presheaf.map (homOfLE …).op` (Mathlib `restrictAdjunction_unit_app_app`
  is `rfl` at section level); the leg-iso `pls.hom` reads (by `rfl`) as `Γ(V, q_*(rFIP.inv)) ≫`
  an `eqToHom` reindex. Composing, all comparison/transport factors are subsingleton `Opens`-homs
  (thin category), so the whole composite collapses to the single `F`-restriction along
  `U_{σ'} ⊓ V ⊆ U_{σ'∘δᵏ} ⊓ V` — exactly the claimed `homOfLE` map.

### 2. Add block `\label{lem:pushPull_leg_coherence}`
`\lean{AlgebraicGeometry.pushPull_leg_coherence}` (note: `private` in Lean — keep the pin but no
`\leanok` will attach; if leandag rejects the private pin, instead bundle the name into
`lem:pushPull_interLegHom_sections`'s `\lean{}` list). Statement: for `q : A ⟶ X`, open immersion
`c : C' ⟶ A`, `pC` with `c ≫ q = pC`, the push–pull map of `Over.homMk c` equals
`q_*(η^c_{q^*F}) ≫ (pushPullLegIso q c pC wC F).hom`, where `pushPullLegIso` bundles
`restrictFunctorIsoPullback`, `pullbackComp`, `pullbackCongr`. One-line proof: unfold
`rawPushPullMap_self_gen`, apply `Adjunction.unit_leftAdjointUniq_hom_app`, `subst wC`, collapse
the `Congr` isos (identities at `rfl`).

### 3. Add substantive blocks (clear coverage debt + checker recommendations)
- `\label{lem:backboneIncl_proj}` `\lean{AlgebraicGeometry.backboneIncl_proj}` — "Stub-1
  unwinding": the `τ`-summand backbone inclusion followed by the `l`-th wide-pullback projection
  equals `interProj`. Proof sketch: reassociate the five layers of `cechBackbone_left_sigma.inv`
  (finitary-pre-extensive distributivity) via the abstract reassociation helpers, then the
  whiskerEquiv-reindex layer composed with `ι_wpci_inv_overWPproj`. `\uses` the backbone/
  pre-extensive defs.
- `\label{lem:backboneIncl_nerveδ}` `\lean{AlgebraicGeometry.backboneIncl_nerveδ}` — per-leg coface
  factorization: the backbone inclusion intertwines the nerve coface `δ^nerve_k` with `interLegHom`
  (the geometric face). Proof: `backbone_hom_ext` + `nerveδ_backboneProj` + `interLegHom_interProj`.
- `\label{lem:coreIso_objIso_π}` `\lean{AlgebraicGeometry.coreIso_objIso_π}` — coordinate formula
  for the degreewise object iso `coreIso_objIso`: its `σ`-projection is `pushPull_eval_prod_iso`'s
  `σ`-leg reindexed by `coverInterOpen_inf_distrib`. `\uses{lem:coreIso_obj_iso,
  lem:pushPull_eval_prod_iso, lem:coverInterOpen_inf_distrib}`.

Then add `lem:pushPull_interLegHom_sections`, `lem:backboneIncl_proj`, `lem:backboneIncl_nerveδ`,
`lem:coreIso_objIso_π` to the **proof** `\uses{}` of `lem:coreIso_comm_leg` (its proof invokes
all four by name).

### 4. Fix the broken pin
In `lem:coreIso_comm_sum` (~L8886), the `\lean{}` list pins
`AlgebraicGeometry.abHom_finsetSum_apply`, which is `private` and unreachable (mangled name).
REMOVE that name from the pin, leaving `\lean{AlgebraicGeometry.coreIso_comm_sum}`. (If you instead
keep a trivial `\label{lem:abHom_finsetSum_apply}` helper block, do NOT pin the private name.)

### 5. Bundle trivial public helper defs (coverage debt, best-effort)
Bundle these public helper names into the `\lean{}` list of the most-related new/existing block
(house convention — gives them dependency edges; trivial entries are fine):
`backboneIncl`, `backboneProj`, `backbone_hom_ext`, `nerveδ_backboneProj`, `cechNerve_drop_δ`,
`coverInterToMember`, `coverInterToMember_fac`, `interProj`, `interLegHom`, `interLegHom_interProj`,
`GVΨ_map_eq`, `sectionFunctorV`. Do not author full blocks for these — bundling suffices.

## Constraints
- Mathematical prose only. NO Lean tactic syntax in `\begin{proof}` bodies. NO `\leanok`/`\mathlibok`.
- Keep statements faithful to the verbatim Lean signatures above.
- These are Archon-bespoke — no `% SOURCE` citations.
