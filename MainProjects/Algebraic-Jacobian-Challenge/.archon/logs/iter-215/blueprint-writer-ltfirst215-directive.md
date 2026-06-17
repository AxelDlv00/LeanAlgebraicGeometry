# Blueprint-writer directive — iter-215 (round 2) — locally-trivial-first group law

## Chapter to edit (ONLY this one)

`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Why this edit

A strategy review identified a materially simpler path to the line-bundle group law than the
route-(e) general `LocalizedMonoidal` instantiation. Route (e) builds the monoidal category on ALL
of `SheafOfModules`, which forces the hardest gap d.2 (stalk ⊗ commutation over a varying ring,
~150–250 LOC, multi-iter). The simpler path — adopted now as the PRIMARY route — exploits local
triviality from the start, mirroring Mathlib's ring-level Picard group, and plausibly never needs
d.2. The substrate (`tensorObj = sheafification(presheaf tensor)`) is UNCHANGED; only the
group-assembly strategy and the proof of the residual lemma change. This is a targeted refinement,
not a rewrite — leave all other blocks, the substrate, and the route-(e) survey intact (route (e)
is retained as the FALLBACK for full monoidal generality).

## Precedent (verified on disk, project's pinned Mathlib)

`Mathlib/RingTheory/PicardGroup.lean`: `Module.Invertible R M` (the canonical map `Mᵛ ⊗[R] M → R`
is an iso); `Module.Invertible.right`/`.left`/`.congr`; instance `Module.Invertible R R`; the
Picard group `CommRing.Pic` is the group of iso-classes of invertible modules under ⊗, built WITHOUT
any monoidal category / `Skeleton` / `MorphismProperty.IsMonoidal`. This is the direct precedent for
"group on iso-classes of invertibles, no monoidal category."

## Required edits

### Edit 1 — add the locally-trivial PRIMARY proof route to `lem:islocallyinjective_whisker_of_W`

The lemma is stated for an arbitrary presheaf of modules `F`. Add, as the PRIMARY proof route (the
existing stalkwise/d.2 argument becomes the explicitly-labelled FALLBACK, needed only for the
full-generality route-(e) `LocalizedMonoidal` path):

When `F` is **locally trivial** (`LineBundle.IsLocallyTrivial F`) — which is exactly the case its
sole consumer, the locally-trivial-scoped associator `lem:tensorobj_assoc_iso`, supplies — local
injectivity of `F ◁ g` is proved **sheaf-level on a trivializing cover, with no stalks and no d.2**:
- On a trivializing open `V` where `F|_V ≅ 𝒪_V`, the substrate-restriction compatibility
  `lem:tensorobj_restrict_iso` gives `(F ◁ g)|_V ≅ (F|_V) ◁ (g|_V)`, and the left unitor
  (`lem:tensorobj_unit_iso`, `𝒪_V ⊗ (-) ≅ (-)`) identifies `(F|_V) ◁ (g|_V) ≅ g|_V`.
- `g ∈ J.W` is stable under restriction, so `g|_V ∈ J.W`, hence `g|_V` is `J`-locally injective.
- `J`-local injectivity is local on a covering family, so `F ◁ g` is locally injective.
This route trades the Mathlib-absent d.2 for the single comparison lemma
`lem:tensorobj_restrict_iso` (presheaf-level comparison, decomposed H1+H2), which thereby moves ONTO
the critical path. Note explicitly: this is NOT the iter-213 section-level route (which hit a
Tor₁/flatness dead end working with section maps `g(V)` that are only injective) — here the argument
is sheaf-level and uses that `g` is locally *bijective* (a `J.W` morphism), reduced to `g|_V` via
the unitor, never tensoring a mere injection.

Keep the existing stalkwise (d.1-bridge + d.2) argument as the labelled FALLBACK, stating it is
required ONLY if the full-generality `(J.W).IsMonoidal` / `LocalizedMonoidal` route is later wanted
(arbitrary `F`), and that the locally-trivial primary route suffices for the group law.

### Edit 2 — reframe the group block `lem:tensorobj_isoclass_commgroup`

Currently the group is described as following from `(J.W).IsMonoidal` → `LocalizedMonoidal` →
`Units(Skeleton)`. Reframe so the PRIMARY construction builds the commutative group **directly on
iso-classes of locally-trivial (invertible) sheaves**, mirroring `Module.Invertible` /
`CommRing.Pic` (`Mathlib/RingTheory/PicardGroup.lean`): the group operation is `[L]·[M] = [L ⊗ M]`
(well-defined and again locally trivial by `lem:tensorobj_lift_onproduct`), the identity is `[𝒪_X]`,
the inverse is the dual `[Lⁱⁿᵛ]` from `lem:tensorobj_inverse_invertible`, associativity is the
locally-trivial associator `lem:tensorobj_assoc_iso`, unit laws the unitors `lem:tensorobj_unit_iso`,
commutativity the braiding `lem:tensorobj_comm_iso`. No `(J.W).IsMonoidal`, no `LocalizedMonoidal`,
no `Skeleton` is required for the GROUP — those remain the route-(e) fallback path for the full
monoidal category only. State that this is the lower-risk path because every ingredient is either
already proved (unitors, braiding) or locally-trivial-scoped and assembled (associator), and the
remaining sorries are `lem:tensorobj_restrict_iso` (now critical) and
`lem:tensorobj_inverse_invertible`.

### Edit 3 — API survey note

In `sec:tensorobj_api_survey` (or `sec:tensorobj_route_e` intro), add one short paragraph noting the
two-tier strategy: (PRIMARY) group on locally-trivial iso-classes à la `Module.Invertible`, needing
only `lem:tensorobj_restrict_iso` + `lem:tensorobj_inverse_invertible` on top of the assembled
locally-trivial associator/unitors/braiding; (FALLBACK) the full `(J.W).IsMonoidal` →
`LocalizedMonoidal` monoidal category on all of `SheafOfModules`, which is deferred because its
load-bearing field needs d.2 (stalk-⊗ over a varying ring, multi-iter).

## Out of scope (do NOT touch)

- The substrate definition, any statement signature of an existing pinned declaration EXCEPT adding
  the locally-trivial route prose to `lem:islocallyinjective_whisker_of_W` (do NOT change its Lean
  `\lean{...}` pin), the route-(e) survey content (keep it as fallback), any other chapter.
- Do NOT add or remove `\leanok`/`\mathlibok` markers.
- Do NOT delete the d.1-core block (`lem:stalk_linear_map`) or the stalkwise fallback prose — they
  remain valid for the fallback route.

## Citations

`Module.Invertible` / `CommRing.Pic` are Mathlib software references — name the file
(`Mathlib/RingTheory/PicardGroup.lean`) in prose; no `% SOURCE QUOTE` literature transcription
needed. No new external reference material is required; `references/**` authorized only as fallback.
