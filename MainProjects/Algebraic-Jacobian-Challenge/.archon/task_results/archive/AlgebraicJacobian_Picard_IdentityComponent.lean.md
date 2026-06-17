# AlgebraicJacobian/Picard/IdentityComponent.lean

## Iter-193 Lane A.3.i prover summary

**File entered iter at 8 sorries / 0 axioms. File exited iter at 9 sorries / GREEN**
(+1 sorry = planner-sanctioned typed sorry for `geometricallyConnected_of_connected_of_section`).

## HARD BAR status: MET ✓

The HARD BAR was "1 axiom-clean Stacks 037Q lemma OR the full Stacks 04KU helper landed
(even with sorry-body — the temporary count increase is sanctioned)".

**Met via the second option**: `geometricallyConnected_of_connected_of_section`
(L414) shipped with the substantive Stacks 04KU signature
(`f : X ⟶ Spec k`, `s : Spec k ⟶ X` with `s ≫ f = 𝟙`, `[ConnectedSpace X]`
⟹ `GeometricallyConnected f`) and a sorry body, plus detailed proof-outline
docstring covering both the Stacks 04KV descent-of-clopen-partitions route
and the Stacks 037Q alg-closure-in-global-sections route.

## PUSH-BEYOND attempts

### Section + GeometricallyConnected instance (3 axiom-clean helpers added)

Three new axiom-clean private declarations make the sorry-bodied helper
**usable** downstream:

1. **`identityComponentSection_range_subset`** (L427, axiom-clean): the
   identity section `(MonObj.one).left : Spec k ⟶ G.left` has range
   contained in `Set.range (identityComponentCarrier G).ι.base` (i.e.,
   `connectedComponent (identitySectionPoint G)`). Proof uses
   `Subsingleton.elim` on `Spec k`'s unique point + `mem_connectedComponent`.

2. **`identityComponentSection`** (L437, axiom-clean): the lift of the
   identity section through `IsOpenImmersion.lift` along
   `(identityComponentCarrier G).ι`, giving a morphism
   `Spec k ⟶ (IdentityComponent G).left`.

3. **`identityComponentSection_isSection`** (L460, axiom-clean): proves
   the section is genuinely a section of `(IdentityComponent G).hom`.
   Proof chain: `change` to unfold `(IdentityComponent G).hom` to
   `(identityComponentCarrier G).ι ≫ G.hom`; `← Category.assoc`;
   `IsOpenImmersion.lift_fac` (via explicit `show ... from` to bypass
   `rw`'s pattern matcher); `exact (MonObj.one).w` for the over-morphism
   compatibility (the terminal of `Over (Spec k)` has `.hom = 𝟙 (Spec k)`
   definitionally).

4. **`identityComponent_geometricallyConnected`** (L500, depends on the
   sorry-bodied helper): the instance
   `GeometricallyConnected (IdentityComponent G).hom`, derived by
   feeding the section + section-property into
   `geometricallyConnected_of_connected_of_section`. Once the helper's
   body closes axiom-clean, this instance becomes axiom-clean
   automatically.

### Engineering insight for instance synthesis

`IsOpenImmersion.lift (identityComponentCarrier G).ι ...` consistently
fails to synthesise `IsOpenImmersion (identityComponentCarrier G).ι` —
even with `haveI` on the previous line, even with explicit
`Scheme.Opens.instIsOpenImmersionι _`, even though the example
`example ... : IsOpenImmersion (identityComponentCarrier G).ι :=
inferInstance` works in isolation. The working pattern was the explicit
`@IsOpenImmersion.lift (identityComponentCarrier G).toScheme (Spec (.of k))
G.left (identityComponentCarrier G).ι ((MonObj.one).left : ...) inferInstance
range-proof` form, providing ALL three universe-level scheme arguments
explicitly. This is a generalizable workaround for the
`IsOpenImmersion.lift` API when the open immersion's source involves
def-folded carrier extraction.

### Stacks 037Q substrate (PUSH-BEYOND, NOT landed)

Attempted but not landed: the Stacks 037Q substrate "scheme is
geometrically connected iff connected + alg-closure of k in Γ(X,𝒪_X)
equals k" is ~30-50 LOC but requires a chain of global-sections /
alg-closure / Galois-orbit substrate not currently in Mathlib at
SHA b80f227. Documented in the helper docstring (L382-413) as the
alternative path to axiom-clean closure.

### Iso slot of baseChangeIso (PUSH-BEYOND, NOT landed)

Attempted but not landed in this iter. The mathematical recipe is now
fully clarified by the new `GeometricallyConnected (IdentityComponent G).hom`
instance + Mathlib's `[GeometricallyConnected f] [UniversallyOpen f]
[ConnectedSpace Y] ⟹ ConnectedSpace (pullback f g)` instance:

1. Construct the open immersion `pullback (IdentityComponent G).hom φ ⟶
   pullback G.hom φ = G_K.left` via `pullback.map (IdentityComponent G).hom
   φ G.hom φ ι (𝟙 _) (𝟙 _) ...`. Open immersion status follows from
   `Scheme.pullback_map_isOpenImmersion` (i₁ = ι is OI, i₂ = 𝟙 is OI,
   i₃ = 𝟙 is mono).
2. Show the range = preimage of `identityComponentCarrier G` under
   `pullback.fst G.hom φ : pullback G.hom φ → G.left`.
3. Show this preimage equals `connectedComponent (identitySectionPoint G_K)
   = (identityComponentCarrier G_K)` (as Sets in G_K.left). Both directions:
   - (⊇) `connectedComponent` is contained in any clopen set containing
     the identity (standard topology). The preimage is clopen (preimage
     of clopen) and contains the identity (base-change of the section).
   - (⊆) The preimage is connected (via the new `GeometricallyConnected
     (IdentityComponent G).hom` instance, chained with `UniversallyOpen φ`
     and `ConnectedSpace Spec K`). Connected + contains identity →
     contained in connected component.
4. Apply `IsOpenImmersion.isoOfRangeEq` to construct the iso between
   `pullback (IdentityComponent G).hom φ` and `(identityComponentCarrier G_K).toScheme
   = (IdentityComponent G_K).left`.

Estimated 80-120 LOC. Deferred to iter-194+ due to time budget; the
substrate `identityComponent_geometricallyConnected` instance landed this
iter is the critical preparation.

## Axiom-clean section summary

| Declaration | Status | Notes |
|---|---|---|
| `geometricallyConnected_of_connected_of_section` (NEW L414) | typed sorry | HARD BAR; planner-sanctioned |
| `identityComponentSection_range_subset` (NEW L427) | axiom-clean | |
| `identityComponentSection` (NEW L437) | axiom-clean | |
| `identityComponentSection_isSection` (NEW L460) | axiom-clean | |
| `identityComponent_geometricallyConnected` (NEW L500) | sorry-bodied (via helper) | propagates through helper sorry |
| `identityComponentCarrier_connectedSpace` (iter-192) | axiom-clean | unchanged |
| `identityComponent_connectedSpace` (iter-192) | axiom-clean | unchanged |
| `IdentityComponent.isOpenSubgroupScheme` (iter-186/187) | axiom-clean | unchanged |
| `IdentityComponent.isSubgroupHomomorphism` | sorry (unchanged) | |
| `IdentityComponent.isFiniteTypeGeometricallyIrreducible` | partial (LFT clean; QC+GI sorry) | unchanged |
| `IdentityComponent.baseChangeIso` | partial (2/3 closed; iso slot sorry) | unchanged |
| `Pic0Scheme` (def) | sorry | gated on `[LFT PicScheme.hom]` (sibling) |
| `PicScheme.degree` (def) | sorry | gated on Hilbert-polynomial machinery |
| `Pic0Scheme.isAbelianVariety` | sorry | gated on Pic0Scheme |
| `Pic0Scheme.finrank_eq_genus` | sorry | gated on Pic0Scheme |
| `Pic0Scheme.kPoints_iff_kerDegree` | sorry | gated on Pic0Scheme |

## Sorry count: 8 → 9 (+1, planner-sanctioned)

Pre-iter: 8 sorries (the 5 file-skeleton pin sorries + 3 partial-closure
sorries on `isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`
QC+GI branch, `baseChangeIso` iso slot).

Post-iter: 9 sorries — the additional sorry is the
`geometricallyConnected_of_connected_of_section` helper body. The
planner-set HARD BAR explicitly authorises this temporary count
increase: "the temporary count increase is sanctioned".

## Concrete next steps (iter-194+)

1. **Close `geometricallyConnected_of_connected_of_section` axiom-clean**
   via either:
   - Stacks 037Q substrate (~30-50 LOC, project-local; alg-closure-of-k-in-
     Γ-equals-k argument with the section as a retraction);
   - Stacks 04KV descent of clopen partitions along surjective fpqc base
     change (requires substantive Mathlib infrastructure; gated).
2. **Close iso slot of `baseChangeIso`** via the 4-step recipe documented
   above. The `identityComponent_geometricallyConnected` substrate is
   landed; the remaining work is the `IsOpenImmersion.isoOfRangeEq`
   construction + range-equals-connected-component argument.
3. **`isSubgroupHomomorphism`** body via `μ(G^0 × G^0) ⊆ G^0` (Kleiman §5).
   The new `GeometricallyConnected` instance + Mathlib's pullback-
   connectedness instance now give `ConnectedSpace (pullback (IdentityComponent G).hom (IdentityComponent G).hom)`
   for free; the remaining work is constructing the `GrpObj` structure
   (multiplication / inverse / unit) via image-of-connected arguments.
4. **`isFiniteTypeGeometricallyIrreducible`** QC + GI branch via Kleiman's
   group-translation cover (after `isSubgroupHomomorphism`).
5. **`Pic0Scheme` def body**: needs `[LocallyOfFiniteType (PicScheme C).hom]`
   from sibling `Picard/FGAPicRepresentability.lean` (Kleiman §4
   structure: Pic is locally of finite type as disjoint union of
   quasi-projectives).

## Lemmas / patterns discovered (for plan agent)

- `@IsOpenImmersion.lift X Y Z f g inferInstance H'` workaround when
  `IsOpenImmersion.lift f g H'` fails instance synthesis on `f` despite
  the instance being readily available.
- `(MonObj.one (X := G)).w` for the over-morphism compatibility
  `MonObj.one.left ≫ G.hom = (𝟙_).hom = 𝟙 (Spec k)` (the terminal's
  `.hom` is `𝟙` definitionally in `Over (Spec k)`).
- `Scheme.pullback_map_isOpenImmersion`: `pullback.map ... i₁ i₂ i₃ ...`
  is `IsOpenImmersion` when `i₁` and `i₂` are open immersions and `i₃`
  is mono. Direct route for base-change-of-open-immersion in pullback
  diagrams.

## Search results (for plan agent's task_pending merge)

- Searched `pullback.map IsOpenImmersion base change` → found
  `AlgebraicGeometry.Scheme.pullback_map_isOpenImmersion` (Mathlib).
- Searched `two open subschemes same carrier isomorphic` → found
  `IsOpenImmersion.isoOfRangeEq` (Mathlib): given two open immersions
  with same range, produces an iso between sources.
- Searched `pullback pasting two morphisms compose iso` → found
  `pullbackRightPullbackFstIso` (Mathlib): `pullback f' (pullback.fst f g)
  ≅ pullback (f' ≫ f) g`.

## Markers status (for review agent)

Blueprint chapter: `blueprint/src/chapters/Picard_IdentityComponent.tex`

All `\lean{...}` pins resolve to the existing typed-sorry declarations
(no changes). The new `geometricallyConnected_of_connected_of_section`
helper is PRIVATE and not blueprint-pinned (it's project-internal
infrastructure, not a Kleiman-conclusion blueprint declaration).

No `\leanok` changes since no full closures landed; `sync_leanok` will
maintain current state.
