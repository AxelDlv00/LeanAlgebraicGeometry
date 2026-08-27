import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Separation.Hausdorff

/-!
# Quasi-compactness and separation

This module records the terminology used in the Stacks Project's topology
chapter.  Mathlib calls a quasi-compact subset `IsCompact`; the definitions
below keep the source terminology while exposing the existing API.
-/

namespace StacksPart01

open Set

/-- A subset is quasi-compact when every open cover has a finite subcover.

This is the Stacks Project's `topology-definition-quasi-compact` terminology;
the proposition is definitionally Mathlib's `IsCompact`.
-/
def IsQuasiCompact {X : Type*} [TopologicalSpace X] (s : Set X) : Prop :=
  IsCompact s

/-- A space is quasi-compact when its underlying set is quasi-compact. -/
def QuasiCompactSpace (X : Type*) [TopologicalSpace X] : Prop :=
  IsQuasiCompact (Set.univ : Set X)

/-- The Stacks notion of a quasi-compact continuous map. -/
def IsQuasiCompactMap {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    (f : X → Y) : Prop :=
  Continuous f ∧
    ∀ ⦃V : Set Y⦄, IsOpen V → IsQuasiCompact V →
      IsQuasiCompact (f ⁻¹' V)

/-- A subset is retrocompact when its intersection with every
quasi-compact open is quasi-compact. -/
def Retrocompact {Y : Type*} [TopologicalSpace Y] (s : Set Y) : Prop :=
  ∀ ⦃V : Set Y⦄, IsOpen V → IsQuasiCompact V → IsQuasiCompact (s ∩ V)

/-- Quasi-compact maps are closed under composition (Stacks, Tag 005B). -/
theorem isQuasiCompactMap_comp {X Y Z : Type*}
    [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace Z]
    {f : X → Y} {g : Y → Z} (hf : IsQuasiCompactMap f)
    (hg : IsQuasiCompactMap g) :
    IsQuasiCompactMap (g ∘ f) := by
  refine ⟨hg.1.comp hf.1, ?_⟩
  intro V hV hVcompact
  have hgp : IsCompact (g ⁻¹' V) := hg.2 hV hVcompact
  have hopen : IsOpen (g ⁻¹' V) := hV.preimage hg.1
  have hfp : IsCompact (f ⁻¹' (g ⁻¹' V)) := hf.2 hopen hgp
  simpa [IsQuasiCompact, Function.comp_def, Set.preimage_preimage] using hfp

/-- The image of a quasi-compact map is retrocompact (Stacks, Tag 04Z9). -/
theorem image_retrocompact {X Y : Type*}
    [TopologicalSpace X] [TopologicalSpace Y]
    {f : X → Y} (hf : IsQuasiCompactMap f) :
    Retrocompact (Set.range f) := by
  intro V hV hVcompact
  have hpre : IsCompact (f ⁻¹' V) := hf.2 hV hVcompact
  have himage : IsCompact (f '' (f ⁻¹' V)) := hpre.image hf.1
  simpa [IsQuasiCompact, Set.image_preimage_eq_inter_range, Set.inter_comm] using himage

/-- The continuous image of a quasi-compact space is quasi-compact
(Stacks, Tag 04Z9, part (1)). -/
theorem image_quasiCompact {X Y : Type*}
    [TopologicalSpace X] [TopologicalSpace Y]
    {f : X → Y} (hX : QuasiCompactSpace X) (hf : Continuous f) :
    IsQuasiCompact (Set.range f) := by
  have hX' : IsCompact (Set.univ : Set X) := hX
  have h' := hX'.image hf
  simpa [IsQuasiCompact, Set.image_univ] using h'

/-- A closed subset of a quasi-compact subset is quasi-compact
(Stacks, Tag 005C). -/
theorem closed_subset_quasiCompact {X : Type*} [TopologicalSpace X]
    {s t : Set X} (hs : IsQuasiCompact s) (ht : IsClosed t) (hsub : t ⊆ s) :
    IsQuasiCompact t := by
  exact hs.of_isClosed_subset ht hsub

/-- A closed subset of a quasi-compact space is quasi-compact. -/
theorem closed_subset_of_quasiCompact_space {X : Type*} [TopologicalSpace X]
    (hX : QuasiCompactSpace X) {t : Set X} (ht : IsClosed t) :
    IsQuasiCompact t := by
  exact closed_subset_quasiCompact hX ht (Set.subset_univ t)

/-- In a compact Hausdorff space, quasi-compact subsets are exactly closed
subsets (Stacks, Tag 08YC). -/
theorem quasiCompact_iff_closed {X : Type*} [TopologicalSpace X]
    [CompactSpace X] [T2Space X] {s : Set X} :
    IsQuasiCompact s ↔ IsClosed s := by
  constructor
  · intro hs
    exact hs.isClosed
  · intro hs
    exact hs.isCompact

/- Quasi-compact subsets of a Hausdorff space are closed (Stacks, Tag 08YB). -/
theorem quasiCompact_isClosed {X : Type*} [TopologicalSpace X]
    [T2Space X] {s : Set X} (hs : IsQuasiCompact s) : IsClosed s := by
  exact hs.isClosed

/- Finite unions of quasi-compact subsets are quasi-compact. -/
theorem quasiCompact_union {X : Type*} [TopologicalSpace X]
    {s t : Set X} (hs : IsQuasiCompact s) (ht : IsQuasiCompact t) :
    IsQuasiCompact (s ∪ t) := by
  exact hs.union ht

/- Finite products of quasi-compact subsets are quasi-compact. -/
theorem quasiCompact_prod {X Y : Type*}
    [TopologicalSpace X] [TopologicalSpace Y]
    {s : Set X} {t : Set Y} (hs : IsQuasiCompact s) (ht : IsQuasiCompact t) :
    IsQuasiCompact (s ×ˢ t) := by
  exact hs.prod ht

/- In a Hausdorff space, intersections of quasi-compact subsets are quasi-compact. -/
theorem quasiCompact_inter {X : Type*} [TopologicalSpace X] [T2Space X]
    {s t : Set X} (hs : IsQuasiCompact s) (ht : IsQuasiCompact t) :
    IsQuasiCompact (s ∩ t) := by
  exact hs.inter ht

/-- Hausdorffness is equivalent to closedness of the diagonal
(Stacks, Tag 08ZE). -/
theorem hausdorff_iff_closed_diagonal (X : Type*) [TopologicalSpace X] :
    T2Space X ↔ IsClosed (Set.diagonal X) :=
  t2_iff_isClosed_diagonal

end StacksPart01
